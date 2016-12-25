defmodule B10g.AcmeController do
	use B10g.Web, :controller

  defp get_key(token) do
    Enum.reduce(
      0..3,
      fn (x, acc)->
        IO.inspect acc
        case System.get_env("ACME_TOKEN_" <> "#{x}") == token do
          true ->
            [System.get_env("ACME_KEY_" <> "#{x}")]
          _ ->
            []
        end
      end) |> List.first
  end

  def validate(conn, %{"token" => token}) do
    case get_key(token) do
      nil ->
        conn
        |> put_status(:not_found)
        |> text("not found")
      key ->
        conn
        |> text(key)
    end
    text(conn, "hello")
  end
  
end