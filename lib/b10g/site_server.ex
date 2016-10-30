defmodule B10g.SiteServer do
  use GenServer
  alias B10g.Site
  alias B10g.Repo

  def start_link do
    # feedback
    case Mix.env do
      :test ->
        nil
      _ ->
        IO.puts "starting siteserver"
    end

    # start the genserver
    GenServer.start_link(__MODULE__, [], name: :siteserver)
  end

  def init (_) do
      {:ok, Repo.all(Site)}
  end

  def handle_call({:reload}, _from, _sites) do
      {:reply, :ok, Repo.all(Site)}
  end

  def handle_call({:get, cname}, _from, sites) do
		case Enum.filter(sites, fn(site)-> Map.get(site, :cname) == cname end) do
			[site] ->
				# return the updated user struct
				{:reply, {:ok, site}, sites}
			_ ->
				{:reply, {:error, :site_not_found}, sites}
		end
  end
end