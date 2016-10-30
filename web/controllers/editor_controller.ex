defmodule B10g.EditorController do
  use B10g.Web, :controller

  plug :put_layout, "editor.html"
  plug B10g.AuthPlug

  def ui(conn, _params) do
    conn
    |> render("ui.html")
  end
end
