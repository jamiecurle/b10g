defmodule B10g.PageControllerTest do
  use B10g.ConnCase

  setup do
    B10g.SiteServer.start_link
    :ok
  end

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert conn.status == 200
  end
end
