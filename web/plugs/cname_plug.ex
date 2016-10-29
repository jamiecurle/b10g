defmodule B10g.CnamePlug do

  	def init(opts) do
  	end

  	def call(conn, _opts) do
  	  IO.inspect conn.host
  	  conn
  	end

end