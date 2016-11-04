defmodule B10g.EditorController do
  use B10g.Web, :controller
  alias B10g.Post

  plug :put_layout, "app.html"
  plug B10g.AuthPlug


  def update(conn, %{"id" => id, "post" => post_params}) do
    # get the post
    post = Post
			|> Post.posts_for_site(conn.assigns.site)
			|> Repo.get(id)

    case post do
	    # no post so 404
      nil ->
        conn
        |> put_status(:not_found)
        |> render(B10g.ErrorView, "404.html")

			# have post so attempt to update
      post ->
				cs = Post.changeset(post, post_params)

      	case Repo.update(cs) do
      	  {:ok, post} ->
						conn
						|> redirect(to: editor_path(conn, :ui, id))
					{:error, cs} ->
						conn
						|> render("ui.html", post: post, cs: cs)
      	end
    end
  end

	def update(conn, %{"id" => id}) do
	  conn
	  |> redirect(to: editor_path(conn, :ui, id))
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
