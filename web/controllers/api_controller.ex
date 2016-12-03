 defmodule B10g.APIController do
	use B10g.Web, :controller
	alias B10g.Post

	def create(conn, %{"title" => title, "markdown" => markdown, "slug" => slug,"status" => status,"site_id" => site_id,"inserted_at" => inserted_at}) do
		# TODO: clear this up
		# make sure we cannot insert posts for other peoples blogs
    site_ids = Enum.map(
				Repo.preload(conn.assigns[:current_user], :sites).sites,
				fn(site) -> site.id end)

		# site id needs to be an integer
		site_id = case is_integer(site_id) do
		  true ->
		  	site_id
		  false ->
		  {parsed_site_id, _} = Integer.parse(site_id)
		  parsed_site_id
		end


    case Enum.member?(site_ids, site_id) do
      true ->
        # make changeset

        cs = Post.changeset(
	        %Post{},
  	      %{title: title,
  	        markdown: markdown,
  	        slug: slug,
  	        status: status,
  	        site_id: site_id,
  	        user_id: conn.assigns[:current_user].id,
  	        inserted_at: inserted_at})

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
        |> json(%{status: "error", message: "No matching site found"})
    end
  end

	def create(conn, _params) do
		conn
		|> put_status(400)
		|> json(%{status: "error", message: "Missing parameters: title, markdown, slug, status site_id, and inserted are all required"})
	end


end
