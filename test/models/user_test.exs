defmodule B10g.UserModelTests do
    use B10g.ModelCase
    alias B10g.User

		test "registration changeset creates apikey", %{} do

			# make user with an API key
			apikey = :crypto.hash(:md5, "#{:rand.uniform}")
								|> Base.encode16
								|> String.downcase
		  cs = %User{}
		  		|> User.registration_changeset(%{apikey: apikey, email: "z@y.x", password: "xxxxxxx"})

		  # Save it, the apikey matches above
		  {:ok, u} = Repo.insert(cs)
		  assert u.apikey == apikey

		  # make another changeset with no apikey. The changeset makes one and it is not
		  # the same as the one above
		  cs = %User{}
		  		|> User.registration_changeset(%{email: "z@y.x", password: "xxxxxxx"})
		  {:ok, u} = Repo.insert(cs)
		  assert u.apikey != apikey
			assert 32 == String.length(u.apikey)
		end
end