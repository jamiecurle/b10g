defmodule B10g.AuthController do
  use B10g.Web, :controller
  alias B10g.Repo
  alias B10g.User
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def login(conn, %{"email" => email, "password" => password}) do

    case _auth_with_username_and_password(conn, email, password, repo: Repo) do
      {:ok, conn} ->
        conn
          |> redirect(to: page_path(conn, :index))
      {:error, _reason, conn} ->
        conn
          |> render("login.html", errors: true)
    end
  end

  def login(conn, _params) do
    render(conn, "login.html")
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

  defp _auth_with_username_and_password(conn, email, password, opts) do
    # get the repo and fetch matching user
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(User, email: email)

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