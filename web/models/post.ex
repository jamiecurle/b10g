# todo: later on put in status as a enum CREATE, DRAFT, PUBLISHED, ARCHIVE

defmodule B10g.Post do
  use B10g.Web, :model
  use Timex.Ecto.Timestamps

  @post_status ~w(DRAFT PUBLISHED)

  @derive {Poison.Encoder, only: [:id, :title, :body, :string, :markdown, :slug, :hidden]}
  schema "posts" do
    field :title, :string
    field :body, :string
    field :slug, :string
    field :markdown, :string
    field :status, :string, default: "DRAFT"

    belongs_to :site, B10g.Site
    belongs_to :user, B10g.User

    timestamps()
  end

  @required_fields ~w(title slug markdown site_id user_id status)
  @optional_fields ~w(inserted_at updated_at)

	def valid_statuses, do: @post_status

  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(user_id ), @optional_fields)
  end


	@doc """
	Gets the posts for a site
	"""
	def posts_for_site(query, site) do
	  from p in query,
	  	where: p.site_id == ^site.id,
	  	preload: [:user, :site]
	end

	def published_posts_for_site(query, site) do
		query
		|> posts_for_site(site)
		|> where([p], p.status == "PUBLISHED")
	end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required([:title, :markdown, :slug, :status])
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