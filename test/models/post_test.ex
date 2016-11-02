defmodule B10g.PostModelTests do
    use B10g.ModelCase
    alias B10g.Factory

    test "posts for site", %{} do
      # make two posts
      u1 = Factory.create_user(%{email: "b@c.d"})
      u2 = Factory.create_user(%{email: "d@c.e"})

      # make two sites
      s1 = Factory.create_site(%{user_id: u1.id})
      s2 = Factory.create_site(%{user_id: u2.id})

      # now make two posts

      IO.inspect u1
      IO.inspect u2
    end
end