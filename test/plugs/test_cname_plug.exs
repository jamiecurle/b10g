defmodule B10g.CnamePlugTest do
  use B10g.ConnCase

  setup do
    B10g.SiteServer.start_link
    :ok
  end

  test "GET blog with host", %{site: site} do

		# build conn with host
  	conn = build_conn
  					|> Map.put(:host, site.cname)
  					#|> Map.put(:host, "asdadas.asdsadasd.asd")

		# get the index and we get the x-b10g-host header
    conn = get(conn, "/")
    IO.inspect conn.private[:site]

    # it was 200
    assert conn.status == 200
  end
end
