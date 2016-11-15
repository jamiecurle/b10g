defmodule B10g.APIController do
	use B10g.Web, :controller
	alias B10g.Post

	def create(conn, %{"post" => post}) do
		# make sure we cannot insert posts for other peoples blogs
    site_ids = Enum.map(
      Repo.preload(conn.assigns[:current_user], :sites).sites,
      fn(site) -> site.id end)

    case Enum.member?(site_ids, post["site_id"]) do
      true ->
        # make changeset
        cs = Post.changeset(%Post{}, post)

        case Repo.insert(cs) do
          {:ok, _post} ->
            conn
            |> put_status(201)
            |> render("create.json", status: "success")

          {:error, cs} ->
            conn
            |> put_status(400)
            |> render("errors.json", status: "error", changeset: cs)
        end

      false ->
        conn
        |> put_status(400)
        |> json(%{status: "error"})
    end




	end
end
