defmodule B10g.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "posts:*", B10g.PostChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
