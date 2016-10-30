defmodule B10g.Router do
  use B10g.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug B10g.CnamePlug
    plug B10g.UserPlug, repo: B10g.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # the editor
  scope "/editor", B10g do
    pipe_through :browser

    get "/create", EditorController, :create
    get "/ui", EditorController, :ui

  end

	# the authentication views
  scope "/auth", B10g do
    pipe_through :browser

    post "/login", AuthController, :login
    get "/login", AuthController, :login
  end

	# the blog views
  scope "/", B10g do
    pipe_through :browser

    get "/", PageController, :index
  end

end
