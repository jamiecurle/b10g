defmodule B10g.APIAuthPlug do
  import Plug.Conn

  def init(_opts) do
  end

  def call(conn, _opts) do
    case get_req_header(conn, "Authorization") do
      # no authorization header, no dice
      [] ->
        conn
         |> put_resp_content_type("application/json")
         |> send_resp(:forbidden, Poison.encode!(%{error: "Invalid authorization header"}))
         |> halt()
      [token] ->
        IO.inspect token
    end
  end
end