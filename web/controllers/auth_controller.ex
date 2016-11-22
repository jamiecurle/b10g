defmodule B10g.AuthController do
  use B10g.Web, :controller
  alias B10g.Repo
  alias B10g.User
  alias B10g.Site
  import B10g.Auth, only: [checkpw: 2, dummy_checkpw: 0]
  import Ecto.Query, only: [from: 2]


  def login(conn, %{"email" => email, "password" => password}) do
    next = Map.get(conn.params, "next", page_path(conn, :index))
    case _auth_with_username_and_password(conn, email, password, conn.assigns[:site], repo: Repo) do
      {:ok, conn} ->
        conn
          |> redirect(to: next)
      {:error, _reason, conn} ->
        conn
          |> render("login.html", errors: true)
    end
  end

  def login(conn, _params) do
    case conn.assigns[:site] do
      :not_found ->
        conn
        |> put_status(:not_found)
        |> render(B10g.ErrorView, "404.html")
      _ ->
       conn |> render("login.html")
    end
  end

  #
  # Private
  #

  defp _auth(conn, user) do
    conn
      |> fetch_session
      |> assign(:current_user, user)
      |> put_session(:user_id, user.id)
      |> configure_session(renew: true)
  end

  defp _auth_with_username_and_password(conn, _email, _password, site, _opts) when site == :not_found do
    {:error, :not_found, conn}
  end

  defp _auth_with_username_and_password(conn, email, password, site, opts) do
    # get the repo and fetch matching user
    repo = Keyword.fetch!(opts, :repo)
    site_id = site.id

    # get the user that matches the current site id
    q = from u in User,
        inner_join: s in Site,
        on: s.user_id == u.id,
        where: u.email == ^email,
        where: s.id == ^site_id,
        where: s.user_id == u.id

    # TODO - is there a better way to do this?
    user = repo.all(q) |> List.first

    # if user and pw checks out, auth, else error
    cond do
      user && checkpw(password, user.password_hashed) ->
        {:ok, _auth(conn, user)}

      user ->
        dummy_checkpw()
        {:error, :unauthorized, conn}

      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end
end