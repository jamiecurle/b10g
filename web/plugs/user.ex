defmodule B10g.UserPlug do
  import Plug.Conn
  import Ecto.Query

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    case Map.get(conn.assigns, :current_user) do
      nil ->
      	case get_session(conn, :user_id) do
      		nil ->
      			conn
      		user_id ->
      		 user = repo.get(B10g.User, user_id)
      		 				|> repo.preload([:sites])
      		 assign(conn, :current_user, user)
      	end
      _ ->
        conn
    end
  end
end