defmodule B10g.EditorControllerTest do
  use B10g.ConnCase
  alias B10g.Factory

  setup %{user: user, site: site, conn: conn} do
		# start the site server
    B10g.SiteServer.start_link

    # make a post
		{:ok, post} = Factory.create_post(%{user_id: user.id, site_id: site.id})

		# make the url
		url = editor_path(@endpoint, :ui, post.id)

		# make a good_conn that is connected to this domain
		good_conn = build_conn
		            |> Map.put(:host, site.cname)

    # return the things
    {:ok,
    user: user,
    site: site,
    good_conn: good_conn,
    bad_conn: conn,
    post: post,
    url: url}
  end

	# TODO - ensure can only get posts that belong to the site
	test "404 on :ui if post does not belong to the site", %{user: user, good_conn: good_conn, post: post, url: url} do
		# make another site & user
 		{:ok, u2} = Factory.create_user(%{email: "d@c.e"})
    {:ok, s2} = Factory.create_site(%{user_id: u2.id})

		# get the ui and is 200
		conn = good_conn
					 |> assign(:current_user, user)
					 |> get(url)
		assert 200 == conn.status

    # update post
    cs = Post.changeset(post, %{site_id: s2.id, user_id: u2.id })
		Repo.update(cs)

		# get the ui and is 404
		conn = good_conn
					 |> assign(:current_user, user)
					 |> get(url)
		assert 404 == conn.status
	end

	test "404 on :update if post does not belong to the site",  %{good_conn: good_conn, post: post, user: user} do
    # make url
    url = editor_path(@endpoint, :update, post.id)

    # make params
    post_params = %{title: "TEST", slug: "test-test", markdown: "*yo\n*yo", status: post.status}

	  # post to the url - 302
	  conn = good_conn
					 |> assign(:current_user, user)
					 |> put(url, post: post_params)
		assert 302 == conn.status


		# make another site & user
 		{:ok, u2} = Factory.create_user(%{email: "d@c.e"})
    {:ok, s2} = Factory.create_site(%{user_id: u2.id})

    # update post
    cs = Post.changeset(post, %{site_id: s2.id, user_id: u2.id })
		Repo.update(cs)

	  # post to git the url
	  conn = good_conn
					 |> assign(:current_user, user)
					 |> put(url, post: post_params)
		assert 404 == conn.status
	end


  test "POST /editor/ui/update saves the post", %{good_conn: good_conn, post: post, user: user} do
    # make url
    url = editor_path(@endpoint, :update, post.id)

    # make params
    post_params = %{title: "TEST", slug: "test-test", markdown: "*yo\n*yo", status: post.status}


	  # post to the url - 302
	  conn = good_conn
					 |> assign(:current_user, user)
					 |> put(url, post: post_params)

    # get the post
    p = Repo.get(Post, post.id)

    # p now different to the original
		assert p.title != post.title
		assert p.slug != post.slug
		assert p.body != post.body
		assert p.markdown != post.markdown

		# conn redirects back to ui
		assert redirected_to(conn) == editor_path(conn, :ui, p.id)
  end

  test "/editor/create works as expected", %{good_conn: good_conn, user: user} do
    # make url
    url = editor_path(@endpoint, :create)

    # get the post count
    count = Repo.all(Post) |> Enum.count

    # call the url
		conn = good_conn
	  	|> assign(:current_user, user)
	  	|> get(url)

    # we now have one more post
    assert count + 1 == Repo.all(Post) |> Enum.count

    # it redirected to editor / id
    assert redirected_to(conn) =~ "/editor/ui"
  end

  test "GET UI and logged in is 200", %{url: url, good_conn: good_conn, user: user} do
    conn = good_conn
           |> assign(:current_user, user)
           |> get(url)

    assert 200 == conn.status
  end

	test "GET UI and not logged in redirect", %{url: url} do
	  conn = get(build_conn, url)
    assert redirected_to(conn) == auth_path(@endpoint, :login) <> "?next=" <> url
	end
end
