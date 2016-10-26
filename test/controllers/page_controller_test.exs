defmodule B10g.PageControllerTest do
  use B10g.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert conn.status == 200
  end
end
