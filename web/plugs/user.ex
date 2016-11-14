defmodule B10g.UserPlug do
  import Plug.Conn

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    case Map.get(conn.assigns, :current_user) do
      nil ->
        user_id = get_session(conn, :user_id)
        user = user_id && repo.get(B10g.User, user_id) |> repo.preload([:sites])
        user_id && repo.get(B10g.User, user_id)
        assign(conn, :current_user, user)
      _ ->
        conn
    end
  end
end