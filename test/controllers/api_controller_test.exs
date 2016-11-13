defmodule B10g.APIControllerTest do
  use B10g.ConnCase


  setup %{site: site, user: user} do
  	# start sit server
    B10g.SiteServer.start_link

    # make url
    url = api_path(@endpoint, :create)

		# setup a connection we can use
    good_conn = build_conn()
          |> put_req_header("accept", "application/json")
          |> put_req_header("authorization", "Bearer #{user.apikey}")
          |> Map.put(:host, site.cname)


		# make the tuple
    {:ok, url: url, site: site, good_conn: good_conn, user: user}
  end


  test "no dupe slugs", %{url: url, site: site, good_conn: good_conn, user: user} do
    # make data
    params = %{
    	site_id: site.id,
    	user_id: user.id,
    	title: "I am an API post",
    	slug: "i-am-an-api-post",
    	body: "<h1>Hello</h1>",
    	markdown: "# Hello",
    	inserted_at: "2014-10-01T06:12:10+0000",
    	updated_at: "2015-11-05T19:46:19+0000"}

		# count the posts
		post_count = Post |> Repo.all |> Enum.count

    # post and it was created
    conn = good_conn |> post(url, post: params)
    assert 201 == conn.status

    # we now have one more post
    assert post_count + 1 == Post |> Repo.all |> Enum.count
  end

  test "post /api/posts/create creates post", %{url: url, site: site, good_conn: good_conn, user: user} do
    # make data
    params = %{
    	site_id: site.id,
    	user_id: user.id,
    	title: "I am an API post",
    	slug: "i-am-an-api-post",
    	body: "<h1>Hello</h1>",
    	markdown: "# Hello",
    	inserted_at: "2014-10-01T06:12:10+0000",
    	updated_at: "2015-11-05T19:46:19+0000"}

		# count the posts
		post_count = Post |> Repo.all |> Enum.count

    # post it - was 201
    conn = good_conn |> post(url, post: params)
		assert 201 == conn.status

    # we now have one more post
    assert post_count + 1 == Post |> Repo.all |> Enum.count

		# send again, was 400
    conn = good_conn |> post(url, post: params)
		assert 400 == conn.status

    # still only have one more
    assert post_count + 1 == Post |> Repo.all |> Enum.count
  end
end