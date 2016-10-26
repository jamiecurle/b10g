# todo: later on put in status as a enum CREATE, DRAFT, PUBLISHED, ARCHIVE

defmodule B10g.Blog do
  use B10g.Web, :model
  use Timex.Ecto.Timestamps


  @derive {Poison.Encoder, only: [:id, :title, :body, :string, :markdown, :slug, :hidden]}
  schema "blogs" do
    field :title, :string
    field :body, :string
    field :slug, :string
    field :markdown, :string

    belongs_to :user, B10g.User

    timestamps()
  end

  @required_fields ~w(title body slug markdown user_id)
  @optional_fields ~w(hidden inserted_at updated_at)

  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(user_id hidden), @optional_fields)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required([:title, :body])
  end

end