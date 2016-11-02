# todo: later on put in status as a enum CREATE, DRAFT, PUBLISHED, ARCHIVE

defmodule B10g.Post do
  use B10g.Web, :model
  use Timex.Ecto.Timestamps


  @derive {Poison.Encoder, only: [:id, :title, :body, :string, :markdown, :slug, :hidden]}
  schema "posts" do
    field :title, :string
    field :body, :string
    field :slug, :string
    field :markdown, :string

    belongs_to :site, B10g.Site
    belongs_to :user, B10g.User

    timestamps()
  end

  @required_fields ~w(title slug markdown site_id user_id)
  @optional_fields ~w(inserted_at updated_at)

  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(user_id ), @optional_fields)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required([:title, :markdown, :slug])
		|> markdown()
  end

  def markdown(changeset) do
  	case changeset do
  		%Ecto.Changeset{valid?: true, changes: %{markdown: _markdown}} ->
  			put_change(changeset, :body, Earmark.to_html(changeset.changes.markdown))
			_ ->
			changeset
  	end

  end

end