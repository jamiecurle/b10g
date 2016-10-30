defmodule B10g.EditorController do
  use B10g.Web, :controller
  alias B10g.Post

  plug :put_layout, "editor.html"
  plug B10g.AuthPlug

  def create(conn, _params) do
    cs = Post.create_changeset(%Post{}, %{user_id: conn.assigns[:site].user_id})
    {:ok, post} = Repo.insert(cs)
    conn
  end

  def ui(conn, _params) do
    conn
    |> render("ui.html")
  end
end
