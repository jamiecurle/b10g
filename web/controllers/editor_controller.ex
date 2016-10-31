defmodule B10g.EditorController do
  use B10g.Web, :controller
  alias B10g.Post

  plug :put_layout, "editor.html"
  plug B10g.AuthPlug

  def create(conn, _params) do
    # make the post - niavely assume it is going to work
    cs = Post.create_changeset(%Post{}, %{user_id: conn.assigns[:site].user_id})
    {:ok, post} = Repo.insert(cs)

    # return a redirect to the editor
    conn
    |> redirect(to: editor_path(conn, :ui, post.id))
  end

  def ui(conn, %{"id" => id}) do
		# get post
		post = Repo.get(Post, id)

		# return the connection
    conn
    |> render("ui.html", post: post)
  end
end
