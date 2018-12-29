defmodule B10g.PageController do
  use B10g.Web, :controller
  alias B10g.Post

  plug :put_layout, "blog.html"

  def healthz(conn, _params) do
    conn
    |> text("k")
  end

  def sitemap(conn, _params) do
    # this is a super quick hack to get my
    # google mojo back. Get all the posts
    # and spew out a sitemap.

    posts = Post
      |> Post.filter(conn.assigns.site, Map.get(conn.assigns, :current_user))
      |> order_by([p], desc: p.inserted_at)
      |> Repo.all

    conn
    |> render("sitemap_url.xml", posts: posts)
  end

  def redirecter(conn, %{"identifer" => identifer}) do
    # now get the post
    post = Post
      |> Post.filter(conn.assigns.site, Map.get(conn.assigns, :current_user))
      |> Post.get(identifer)
      |> Repo.one

    conn
      |> put_status(:moved_permanently)
      |> redirect(to: page_path(conn, :detail, post.slug))
  end

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

    case post do
      nil ->
        conn
         |> put_layout("error.html")
         |> put_status(:moved_permanently)
         |> render(B10g.ErrorView, "404.html", class: "error", title: "Not Found")
      post ->
        conn
         |> render("detail.html", post: post, class: "detail", title: post.title)
    end

  end

  def index(conn, _params) do
    # get the posts
    posts = Post
      |> Post.filter(conn.assigns.site, Map.get(conn.assigns, :current_user))
      |> order_by([p], desc: p.inserted_at)
      |> Repo.all

    # render the page out
    conn
      |> render("index.html", posts: posts, title: "All posts")
  end
end
