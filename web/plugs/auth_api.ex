defmodule B10g.APIAuthPlug do
  import Plug.Conn
  import Ecto.Query, only: [from: 2]
  alias B10g.Site
  alias B10g.User

  def init(_opts) do
  end

  def call(conn, _opts) do
    case get_req_header(conn, "authorization") do
      # no authorization header, no dice
      [] ->
        conn
         |> put_resp_content_type("application/json")
         |> send_resp(:forbidden, Poison.encode!(%{error: "Invalid authorization header"}))
         |> halt()
      [token] ->
        apikey = String.split(token) |> List.last
        q = from u in User,
          inner_join: s in Site,
          on: s.user_id == u.id,
          where: u.apikey == ^apikey,
          where: s.user_id == u.id

        case B10g.Repo.all(q) |> List.first do
          nil ->
            conn
             |> put_resp_content_type("application/json")
             |> send_resp(:forbidden, Poison.encode!(%{error: "User not authorised for this site"}))
             |> halt()
           user ->
            conn
            |> assign(:current_user, user)
        end
    end
  end
end