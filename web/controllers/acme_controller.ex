defmodule B10g.AcmeController do
	use B10g.Web, :controller

  defp get_key(token) do
    # function to determine if token exist
    token_exists? = fn(x, token)-> System.get_env("ACME_TOKEN_" <> "#{x}") == token end

    # if it exists, return the key
    for x <- 0..50, token_exists?.(x, token),  do: System.get_env("ACME_KEY_" <> "#{x}")
  end

  def validate(conn, %{"token" => token}) do
    case get_key(token) do
      [] ->
        conn
        |> put_status(:not_found)
        |> text("not found")
      [key] ->
        conn
        |> text(key)
    end
    text(conn, "hello")
  end
  
end