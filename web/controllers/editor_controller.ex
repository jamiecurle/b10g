defmodule B10g.EditorController do
  use B10g.Web, :controller
  alias B10g.Post
	alias B10g.PostChannel

  plug :put_layout, "app.html"
  plug B10g.BrowserAuthPlug

	def sign(conn, _params) do

    # get the filename
    src_filename = Plug.Conn.get_req_header(conn, "x-filename")
               |> List.first()

    # get the post id
    post_id = Plug.Conn.get_req_header(conn, "x-post-id")
                |> List.first()

    # The filename <site.id>/<post.id>/filename. Me three years now from thanks me
    filename = "#{conn.assigns[:site].id}/#{post_id}/#{src_filename}"

    # get the mimetype
    mimetype = Plug.Conn.get_req_header(conn, "x-filetype")
               |> List.first()

    # config
    config = Application.get_env(:b10g, :aws)

    # the url - 3-eu-west-1.amazonaws.com
    url = "https://#{config[:aws_bucket]}.s3-eu-west-1.amazonaws.com/#{filename}"


    # make the headers
    headers = Map.new
              |> Map.put("x-amz-acl", "public-read")
              |> Map.put("content-type", mimetype)

    # make the url and data
    signed_url = AWSAuth.sign_url(
        config[:access_key_id],
        config[:secret_access_key],
        "PUT",
        url,
        config[:region],
        "s3",
        headers)

    #  now make the data
    data = %{signed_url: signed_url,
            url: url,
            headers: headers}

    # return the data
    json(conn, data)
	end


  def update(conn, %{"id" => id, "post" => post_params}) do
    # get the post
    post = Post
			|> Post.filter(conn.assigns.site, Map.get(conn.assigns, :current_user))
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
      	  	# send the change
      	  	a = PostChannel.broadcast_change(post)
            IO.inspect a
      	  	# return conn
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
    cs = Post.create_changeset(
      %Post{},
      %{user_id: conn.assigns[:site].user_id, site_id: conn.assigns[:site].id})

    # inser the post
    {:ok, post} = Repo.insert(cs)

    # return a redirect to the editor
    conn
    |> redirect(to: editor_path(conn, :ui, post.id))
  end

  def ui(conn, %{"id" => id}) do
		# get post
    post = Post
			|> Post.filter(conn.assigns.site, Map.get(conn.assigns, :current_user))
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
