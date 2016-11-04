defmodule B10g.EditorView do
  use B10g.Web, :view

	# seems like a hack, but at least it is not hard coded in two places
  def post_statuses, do: B10g.Post.valid_statuses
end
