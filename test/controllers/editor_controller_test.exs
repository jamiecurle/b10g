defmodule B10g.EditorControllerTest do
  use B10g.ConnCase
  alias B10g.Factory

  setup %{user: user, site: site, conn: conn} do
		# start the site server
    B10g.SiteServer.start_link

    # make a post
		{:ok, post} = Factory.create_post(%{user_id: user.id})

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
