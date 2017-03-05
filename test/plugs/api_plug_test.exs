defmodule B10g.APIAuthPlugTest do
  use B10g.ConnCase

  setup %{site: site, user: user} do
		# start the site server
    B10g.SiteServer.start_link

    # make url
    url = api_path(@endpoint, :create)

		# make a good_conn that is connected to this domain
		good_conn = build_conn()
		            |> Map.put(:host, site.cname)

    # send the things we need into the tests
    {:ok,	good_conn: good_conn, site: site, user: user, url: url}
  end

  test "requests with valid Bearer == 201", %{site: site, user: user, good_conn: good_conn, url: url} do
    # make data
    params = %{
    	title: "I am an API post",
    	markdown: "# Hello",
    	slug: "i-am-an-api-post",
    	status: "PUBLISHED",
    	site_id: site.id,
    	inserted_at: "2014-10-01T06:12:10+0000"}


    # call the API  - we get a 201
    conn = good_conn
           |> put_req_header("authorization", "Bearer #{user.apikey}")
           |> post(url, params)
    assert 201 == conn.status

  end

  test "requests without valid Bearer == 403", %{site: site, good_conn: good_conn, url: url} do
    # make data
    params = %{
    	title: "I am an API post",
    	markdown: "# Hello",
    	slug: "i-am-an-api-post",
    	status: "PUBLISHED",
    	site_id: site.id,
    	inserted_at: "2014-10-01T06:12:10+0000"}


    # call the API  - we get a 403
    conn = good_conn
           |> post(url, params)
    assert 403 == conn.status

  end

end