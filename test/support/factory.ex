defmodule B10g.Factory do
  alias B10g.User
  alias B10g.Post
  alias B10g.Site
  alias B10g.Repo


  def create_user(params \\ %{}) do
    params = Map.merge(%{name: "Foo Bar",
    										email: "foo@bar.baz",
    										password: "househouse"}, params)

    cs = User.registration_changeset(%User{}, params)

    case cs.valid? do
      true ->
      	Repo.insert(cs)
      _ ->
      	IO.inspect cs.errors
      	nil
    end

  end

	def create_post(params \\ %{}) do
  	# must always have a user_id
		user_id = _get_user_id(params)

		site_id = _get_site_id(params)

		# merge the params with some defaults
	  params = Map.merge(%{title: "A Title",
	  											body: "<h1>Hello</h1>",
	  											markdown: "# Hello",
	  											slug: "a-title",
	  											status: "PUBLISHED",
	  											site_id: site_id,
	  											user_id: user_id}, params)

		# make the changeset
	  cs = Post.changeset(%Post{}, params)

		# if cs valid, return the object
	  case cs.valid? do
      true ->
      	Repo.insert(cs)
      _ ->
      	IO.inspect cs.errors
      	nil
	  end

	end

  def create_site(params \\ %{}) do
  	# must always have a user_id
		user_id = _get_user_id(params)


		# make the params
    params = Map.merge(%{cname: "foo.bar.com",
    										config: %{},
    										user_id: user_id}, params)

		# and make the changeset
    cs = Site.changeset(%Site{}, params)

		# if the changeset is not valid
    case cs.valid? do
      true ->
      	Repo.insert(cs)
      _ ->
      	IO.inspect cs.errors
      	nil
    end

  end

	defp _get_user_id(params) do
		case Map.get(params, :user_id) do
			nil ->
				{ok, u} = create_user()
				u.id
			user_id ->
				user_id
		end
	end

	defp _get_site_id(params) do
		case Map.get(params, :site_id) do
			nil ->
				{ok, u} = create_site()
				u.id
			user_id ->
				user_id
		end
	end

end