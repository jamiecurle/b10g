defmodule B10g.PageController do
  use B10g.Web, :controller
	alias B10g.Post

  plug :put_layout, "blog.html"

	def detail(conn, %{"identifer" => identifer}) do
		# phoenix always passes identifier through as string
		identifer = case Integer.parse(identifer) do
		  {integer, _string} ->
		  	integer
		  :error ->
		  	identifer
		end


		# now get the post
		post = Post
			|> Post.filter(conn.assigns.site, Map.get(conn.assigns, :current_user))
			|> Post.get(identifer)
			|> Repo.one

		# render the page
		conn
		 |> render("detail.html", post: post)
	end


  def index(conn, _params) do
		# get the posts
		posts = Post
			|> Post.filter(conn.assigns.site, Map.get(conn.assigns, :current_user))
			|> Repo.all

		# render the page out
		conn
    	|> render("index.html", posts: posts)
  end
end
