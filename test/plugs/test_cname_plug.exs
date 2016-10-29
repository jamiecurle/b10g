defmodule B10g.CnamePlugTest do
  use B10g.ConnCase

  test "GET blog with host", %{site: site} do
		# build conn with host
  	conn = build_conn
  					|> Map.put(:host, site.cname)

		# get the index and we get the x-b10g-host header
    conn = get(conn, "/")

    # it was 200
    assert conn.status == 200
  end
end
