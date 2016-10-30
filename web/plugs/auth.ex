defmodule B10g.AuthPlug do
  import Plug.Conn
  use Phoenix.Controller
  alias B10g.Router.Helpers

  def init(_opts) do

  end

  def call(conn, _opts) do
    if Map.get(conn.assigns, "current_user") do
      conn
    else
      path = Enum.reduce(conn.path_info, "", fn(x, url)-> url <> "/" <> x end)
      to = Helpers.auth_path(conn, :login) <> "?next=#{path}"
      conn
        |> put_flash(:error, "must be logged in")
        |> redirect(to: to)
        |> halt()
    end
  end

end