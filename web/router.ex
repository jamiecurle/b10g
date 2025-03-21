defmodule B10g.Router do
  use B10g.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug B10g.CnamePlug
    plug B10g.EmbeddedPlug
    plug B10g.UserPlug, repo: B10g.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug B10g.CnamePlug
    plug B10g.APIAuthPlug
  end

	# the blog views
  scope "/", B10g do
    pipe_through :browser

    get "/:whatever", PageController, :reap
    get "/", PageController, :reap

    get "/archive/:identifer", PageController, :detail
    get "/", PageController, :index
  end

  scope "/api", B10g do
    pipe_through :api
    post "/posts/create", APIController, :create
  end

  # the editor
  scope "/editor", B10g do
    pipe_through :browser

    post "/_sign/", EditorController, :sign
    get "/create", EditorController, :create
    get "/ui/:id", EditorController, :ui
    put "/update/:id", EditorController, :update
    get "/update/:id", EditorController, :update
  end

	# the authentication views
  scope "/auth", B10g do
    pipe_through :browser

    post "/login", AuthController, :login
    get "/login", AuthController, :login
  end


end
