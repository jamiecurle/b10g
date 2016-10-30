defmodule B10g.AuthControllerTest do
  use B10g.ConnCase
  alias B10g.Factory


  setup %{user: user, site: site, conn: conn} do
		# start the site server
    B10g.SiteServer.start_link

		# make the url
		url = auth_path(@endpoint, :login)

		# make a good_conn that is connected to this domain
		good_conn = build_conn |> Map.put(:host, site.cname)

    # return the things
    {:ok, user: user, site: site, good_conn: good_conn, bad_conn: conn, url: url}
  end

	# test no matching host is a 404

	test "person A cannot login to person B's' blog", %{good_conn: good_conn, url: url} do
    # make a new site and person
    {:ok, u2} = Factory.create_user(%{email: "a@b.c", name: "Bad Bob"})
    {:ok, s2} = Factory.create_site(%{cname: "a.b.c", user_id: u2.id})

    # good conn is wired to teh default user and thus, login will fail
    assert 200 == post(good_conn, url, %{email: "a@b.c", password: "househouse"}).status

    # start and stop the GenServer again
    GenServer.call(:siteserver, {:reload})

    # now make a conn for s2 and we can login without any issue
    u2_conn = build_conn |> Map.put(:host, s2.cname)
    assert 302 == post(u2_conn, url, %{email: "a@b.c", password: "househouse"}).status

	end


  test "POST /login/auth valid", %{good_conn: good_conn, url: url} do
    # there is already a user with the default credentials
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
