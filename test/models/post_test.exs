defmodule B10g.PostModelTests do
    use B10g.ModelCase
    alias B10g.Factory
    alias B10g.Post

    test "filter behaves as expected", %{} do
      # make two users
      {:ok, u1} = Factory.create_user(%{email: "b@c.d"})
      {:ok, u2} = Factory.create_user(%{email: "d@c.e"})

      # make two sites
      {:ok, s1} = Factory.create_site(%{user_id: u1.id})
      {:ok, s2} = Factory.create_site(%{user_id: u2.id})

      # now make two posts
			{:ok, p1} = Factory.create_post(%{site_id: s1.id, user_id: u1.id})
			{:ok, p2} = Factory.create_post(%{site_id: s2.id, user_id: u2.id})

			# use the query
			posts = Post |> Post.filter(s1) |> Repo.all

			# there was one and the ids match
			assert Enum.count(posts) == 1
			assert p1.id == (Post |> Post.filter(s1) |> Repo.get(p1.id)).id

			# update p2 to belong to s1 & u1
			cs = Post.changeset(p2, %{site_id: s1.id, user_id: u1.id, slug: "if-not-change-error", title: B10g.Names.random_name})
			{:ok, _p2} = Repo.update(cs)

			# now we have two
			assert 2 == Enum.count(Post |> Post.filter(s1) |> Repo.all)

    end
end