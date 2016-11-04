defmodule B10g.PageController do
  use B10g.Web, :controller
	alias B10g.Post

  plug :put_layout, "blog.html"

	def detail(conn, identifer) do
		conn
		 |> render("index.html")
	end


  def index(conn, _params) do

		posts = Post |> Post.published_posts_for_site(conn.assigns.site) |> Repo.all

		conn
    |> render("index.html", posts: posts)
  end
end
