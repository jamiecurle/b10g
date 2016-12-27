defmodule B10g.EmbeddedPlug do
  import Plug.Conn

	def init(_) do
	end

	def call(conn, _opts) do
	  case conn.params["mode"] == "embed" do
	  	false ->
	  		assign(conn, :display, :standard)
	  	true ->
	  		assign(conn, :display, :embed)
	  end
	end

end