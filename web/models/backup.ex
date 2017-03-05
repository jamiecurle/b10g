defmodule B10g.Backup do
  use B10g.Web, :model

  schema "backups" do
    field :blog, :binary
    belongs_to :post, B10g.Post

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:blog])
    |> validate_required([:blog])
  end
end
