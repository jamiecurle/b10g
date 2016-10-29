defmodule B10g.CnamePlug do
  import Plug.Conn
  def init(_opts) do
  end

  def call(conn, _opts) do
    case GenServer.call(:siteserver, {:get, conn.host}) do
      {:ok, site} ->
        conn
        |> put_private(:site, site)
      {:error, _} ->
        conn
        |> put_private(:site, :not_found)
    end
  end

end