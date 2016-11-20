# todo: later on put in status as a enum CREATE, DRAFT, PUBLISHED, ARCHIVE

defmodule B10g.Post do
  use B10g.Web, :model
  use Timex.Ecto.Timestamps

  @post_status ~w(DRAFT PUBLISHED)

  @derive {Poison.Encoder, only: [:id, :title, :body, :string, :markdown, :slug, :hidden, :status]}
  schema "posts" do
    field :title, :string
    field :body, :string
    field :slug, :string
    field :markdown, :string
    field :status, :string, default: "DRAFT"

    belongs_to :site, B10g.Site
    belongs_to :user, B10g.User

    timestamps
  end

  @required_fields ~w(title slug markdown site_id user_id status)
  @optional_fields ~w(inserted_at updated_at)

	def valid_statuses, do: @post_status

  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(user_id site_id), @optional_fields)
    |> random_name()\
  end

  def random_name(changeset) do
    put_change(changeset, :slug, B10g.Names.random_name)
  end


	@doc """
	When user is nil, returns PUBLISHED posts for a site
	When user is not nil, returns ALL posts for a site
	"""
	#TODO: rename this to all so we have Post.all & Post.one
	def filter(query, site, user \\ nil)

	@shortdoc "When site is :notfound"
	def filter(query, site, _user) when is_atom(site) do
	  from p in query,
	  	where: false
	end

	def filter(query, site, user) when is_nil(user) do
	  from p in query,
	  	where: p.site_id == ^site.id,
	  	where: p.status == "PUBLISHED",
	  	preload: [:user, :site]
	end

	def filter(query, site, user) when not is_nil(user) do
	  from p in query,
	  	where: p.site_id == ^site.id,
	  	preload: [:user, :site]
	end

	@doc """
	When identifier is a string, gets a single post from filtered posts by slug
	When identifier is an integer, gets a single post from filtered posts by id
	"""
	def get(query, identifier)


	def get(query, identifer) when is_binary(identifer) do
		from p in query,
			where: p.slug == ^identifer,
	  	preload: [:user, :site]
	end


	def get(query, identifer) when is_integer(identifer) do
		from p in query,
			where: p.id == ^identifer,
			preload: [:user, :site]
	end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required([:title, :markdown, :slug, :status])
    |> unique_constraint(:site_id_slug)
    |> validate_status()
		|> markdown()
  end

	@doc """
	validate the status of the enum
	"""
  def validate_status(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{status: status}} ->
        case Enum.member?(@post_status, status) do
          true ->
            changeset
          false ->
            Ecto.Changeset.add_error(changeset, :status, "#{changeset.changes.status} is not a valid value")
        end
      _ ->
      changeset
    end
  end

	@doc """
	If markdown present in changeset render out html
	"""
  def markdown(changeset) do
  	case changeset do
  		%Ecto.Changeset{valid?: true, changes: %{markdown: _markdown}} ->
  			put_change(changeset, :body, Earmark.to_html(changeset.changes.markdown))
			_ ->
			changeset
  	end
  end

end