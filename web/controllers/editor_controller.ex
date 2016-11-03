defmodule B10g.EditorController do
  use B10g.Web, :controller
  alias B10g.Post

  plug :put_layout, "app.html"
  plug B10g.AuthPlug

  def update(conn, %{"post"=> %{"id" => id, "title" => title, "slug" => slug, "markdown" => markdown, "status" => status}}) do
    # get the post
    post = Post
    			|> Post.posts_for_site(conn.assigns.site)
    			|> Repo.get(id)


		# if we had a post, do something else 404
    case post do
      nil ->
        # 404
        conn
        |> put_status(:not_found)
        |> render(B10g.ErrorView, "404.html")
      post ->

				# make the params
				params = %{
					title: title,
					slug: slug,
					status: status,
					markdown: markdown
				}

				# make the changeset, it should work, so allow non working to blow up
				cs = Post.changeset(post, params)
        Repo.update(cs)

        conn
        |> redirect(to: editor_path(conn, :ui, id))

    end
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
    post = Post
    			|> Post.posts_for_site(conn.assigns.site)
    			|> Repo.get(id)

		# ui or 404
    case post do
      nil ->
        # 404
        conn
        |> put_status(:not_found)
        |> render(B10g.ErrorView, "404.html")

    	post ->
				# make a changeset render
				cs  = Post.changeset(post, %{})
				conn
				|> render("ui.html", post: post, cs: cs)
    end
  end

end
