defmodule B10g.CnamePlugTest do
  use B10g.ConnCase

  setup do
    B10g.SiteServer.start_link
    :ok
  end

  test "GET blog with existing cname", %{site: site} do

		# build conn with host
  	conn = build_conn
  					|> Map.put(:host, site.cname)

		# get the index and we get the site in the private
    conn = get(conn, "/")

    # site id matches
    assert conn.private[:site].id == site.id

    # it was 200
    assert conn.status == 200
  end

  test "GET blog with non-existant cname", _params do

		# build conn with host
  	conn = build_conn
  					|> Map.put(:host, "baz.bar.foo")

		# get the index and we get the site in the private
    conn = get(conn, "/")

    # conn private[:site] is :not_found
    assert conn.private[:site] == :not_found

    # but was still 200
    assert conn.status == 200
  end


end
