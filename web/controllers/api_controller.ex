defmodule B10g.APIController do
	use B10g.Web, :controller
	alias B10g.Post

	def create(conn, %{"post" => post}) do
		# make sure we cannot insert posts for other peoples blogs
		IO.inspect post


		# make changeset
		cs = Post.changeset(%Post{}, post)

		case Repo.insert(cs) do
			{:ok, post} ->
				conn
				|> put_status(201)
				|> render("create.json", status: "success")

			{:error, cs} ->
				conn
				|> put_status(400)
				|> render("errors.json", status: "error", changeset: cs)
		end

	end
end
