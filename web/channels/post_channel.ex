defmodule B10g.PostChannel do
  use B10g.Web, :channel

  def join("posts:" <> post_id, _params, socket) do
  	{:ok, socket}
  end

  def handle_info(:ping, socket) do
    count = socket.assigns[:count] || 1
    push(socket, "ping", %{count: count})
    {:noreply, assign(socket, :count, count + 1)}
  end

  def broadcast_change(post) do
  	safe_post = %{
  		"title": post.title,
  		"slug": post.slug,
  		"status": post.status,
  		"body": post.body,
  	}
    B10g.Endpoint.broadcast("posts:#{post.id}", "change", safe_post)
  end
end