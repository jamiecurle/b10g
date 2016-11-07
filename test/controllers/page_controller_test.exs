defmodule B10g.PageControllerTest do
  use B10g.ConnCase


  setup %{site: site} do
		# start the site server
    B10g.SiteServer.start_link

		# make a good_conn that is connected to this domain
		good_conn = build_conn
		            |> Map.put(:host, site.cname)

    {:ok,	good_conn: good_conn}
  end

  test "GET /", %{good_conn: good_conn} do
    conn = good_conn
     				|> get("/")
    assert conn.status == 200
  end
end
