defmodule B10g.CnamePlug do
  import Plug.Conn
  def init(_opts) do
  end

  def call(conn, _opts) do
    case GenServer.call(:siteserver, {:get, conn.host}) do
      {:ok, site} ->
        conn
        |> assign(:site, site)
        |> assign(:config, site.config)
      {:error, _} ->
        conn
        |> assign(:site, :not_found)
        |> assign(:config, %{})
    end
  end

end
