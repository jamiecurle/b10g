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


  test "no dupe slugs", %{url: url, site: site, good_conn: good_conn} do
    # make data
    params = %{
    	title: "I am an API post",
    	markdown: "# Hello",
    	slug: "i-am-an-api-post",
    	status: "PUBLISHED",
    	site_id: site.id,
    	inserted_at: "2014-10-01T06:12:10+0000"}

		# count the posts
		post_count = Post |> Repo.all |> Enum.count

    # post and it was created
    conn = good_conn |> post(url, params)
    assert 201 == conn.status

    # we now have one more post
    assert post_count + 1 == Post |> Repo.all |> Enum.count
  end

  test "cannot create for sites that user does not own", %{url: url, good_conn: good_conn} do
    # make second site
    {:ok, site} = B10g.Factory.create_site()

    # make data
    params = %{
    	title: "I am an API post",
    	markdown: "# Hello",
    	slug: "i-am-an-api-post",
    	status: "PUBLISHED",
    	site_id: site.id,
    	inserted_at: "2014-10-01T06:12:10+0000"}

		# send again, was 400
    conn = good_conn |> post(url, params)
		assert 400 == conn.status
  end

  test "post /api/posts/create creates post", %{url: url, site: site, good_conn: good_conn} do
    # make data
    params = %{
    	title: "I am an API post",
    	markdown: "# Hello",
    	slug: "i-am-an-api-post",
    	status: "PUBLISHED",
    	site_id: site.id,
    	inserted_at: "2014-10-01T06:12:10+0000"}

		# count the posts
		post_count = Post |> Repo.all |> Enum.count

    # post it - was 201
    conn = good_conn |> post(url, params)
		assert 201 == conn.status

    # we now have one more post
    assert post_count + 1 == Post |> Repo.all |> Enum.count

		# send again, was 400
    conn = good_conn |> post(url, params)
		assert 400 == conn.status

    # still only have one more
    assert post_count + 1 == Post |> Repo.all |> Enum.count
  end
end