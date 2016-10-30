defmodule B10g.EditorController do
  use B10g.Web, :controller

  plug :put_layout, "editor.html"
  plug B10g.AuthPlug

  def ui(conn, _params) do
    cs =  
    conn
    |> render("ui.html", cs: cs)
  end
end
