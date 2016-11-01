defmodule B10g.EditorController do
  use B10g.Web, :controller
  alias B10g.Post

  plug :put_layout, "app.html"
  plug B10g.AuthPlug

  def update(conn, %{"id" => id, "title" => title, "slug" => slug, "markdown" => markdown}) do
    # get the post
    post = Repo.get(Post, id)
          |> Repo.preload([:user])

    IO.inspect title

    # make the params
    params = %{
      title: title,
      slug: slug,
      markdown: markdown
    }

    # make the changeset
    cs = Post.changeset(post, params)
    {:ok, post2} = Repo.update(cs)
    conn
  end

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

		# make a changeset
		cs  = Post.changeset(post, %{})

		# return the connection
    conn
    |> render("ui.html", post: post, cs: cs)
  end
end
