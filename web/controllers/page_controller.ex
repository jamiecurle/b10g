defmodule B10g.PageController do
  use B10g.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
