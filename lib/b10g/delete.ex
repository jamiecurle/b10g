defmodule B10g.Delete do
	import Ecto.Query
	alias B10g.Post
	alias B10g.Repo

  def delete do
    # get all files that where created more 30 days ago and in DRAFT
    posts = Repo.all from p in Post,
    	where: p.updated_at  < datetime_add(^Ecto.DateTime.utc, -30, "day"),
    	where: p.deleted == false,
    	where: p.status == "DRAFT"

		# lock them all
		Enum.map(posts, fn(post) ->
			c = Post.changeset(post, %{deleted: true})
			{:ok, post} = Repo.update(c)
		end)
  end
end