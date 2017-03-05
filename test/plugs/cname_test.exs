defmodule B10g.CnamePlugTest do
  use B10g.ConnCase

  setup %{site: site} do
		# start the site server
    B10g.SiteServer.start_link

		# make a good_conn that is connected to this domain
		good_conn = build_conn()
		            |> Map.put(:host, site.cname)

    {:ok,	good_conn: good_conn, site: site}
  end

  test "GET blog with existing cname", %{good_conn: good_conn, site: site} do

		# get the index and we get the site in the private
  	conn = good_conn
  					|> Map.put(:host, site.cname)
  					|> get("/")

    # site id matches
    assert conn.assigns[:site].id == site.id

    # it was 200
    assert conn.status == 200
  end

  test "GET blog with non-existant cname", _params do

		# build conn with host
  	conn = build_conn()
  					|> Map.put(:host, "baz.bar.foo")
  					|> get("/")

		# get the index and we get the site in the private
    conn = get(conn, "/")

    # conn private[:site] is :not_found
    assert conn.assigns[:site] == :not_found

    # but was still 200
    assert conn.status == 200
  end


end
