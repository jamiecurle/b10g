defmodule B10g.AuthController do
  use B10g.Web, :controller


  def login(conn, _params) do
    render conn, "login.html"
  end
end