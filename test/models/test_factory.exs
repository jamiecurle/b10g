defmodule B10g.FactoryTest do
	use B10g.ModelCase
	alias B10g.Factory

	test "User factory works" do
	  {:ok, u} = Factory.create_user
		assert u.password_hashed != nil
	end

	test "Site factory works" do
	  {:ok, s} = Factory.create_site
	  assert s.id != nil
	end

	test "Post factory works" do
	  {:ok, p} = Factory.create_post
	  assert p.id != nil
	end

end