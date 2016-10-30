defmodule B10g.AuthControllerTest do
  use B10g.ConnCase


  setup %{user: user, site: site, conn: conn} do
		# start the site server
    B10g.SiteServer.start_link

		# make the url
		url = auth_path(@endpoint, :login)

		# make a good_conn that is connected to this domain
		good_conn = build_conn
								|> Map.put(:host, site.cname)

    # return the things
    {:ok, user: user, site: site, good_conn: good_conn, bad_conn: conn, url: url}
  end

	# test no matching host is a 404
	# test one person cannot login to another persons blog


  test "POST /login/auth valid", %{good_conn: good_conn, url: url} do
    conn = post(good_conn, url, %{email: "foo@bar.baz", password: "househouse"})
    assert conn.status == 302
  end

  test "POST /login/auth invalid", %{good_conn: good_conn, url: url} do
    conn = post(good_conn, url, %{email: "nope@nope.com", password: "foofoo"})
    assert conn.status == 200
  end

  test "GET /login/auth", %{conn: conn, url: url} do
    conn = get(conn, url)
    assert conn.status == 200
  end
end
