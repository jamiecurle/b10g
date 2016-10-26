defmodule B10g.Site do
  use B10g.Web, :model
  use Timex.Ecto.Timestamps

  schema "sites" do
    field :cname, :string
    field :config, :map

    belongs_to :user, B10g.User

    timestamps()
  end

  @required_fields ~w(cname)
  @optional_fields ~w(config)

  def changeset(model, params \\ %{}) do
    model
      |> cast(params, @required_fields, @optional_fields)
  end

end
