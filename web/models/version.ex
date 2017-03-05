defmodule B10g.Version do
  use B10g.Web, :model

  schema "versions" do
    field :data, :binary
    field :markdown, :string, virtual: true

    belongs_to :post, B10g.Post

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:data, :markdown, :post_id])
    |> markdown_to_term()
    |> validate_required([:data, :markdown, :post_id])
  end

  def markdown_to_term(changeset) do
    case Map.get(changeset.changes, :markdown) do
      nil ->
        changeset
      markdown ->
        put_change(
          changeset,
          :data,
          :erlang.term_to_binary(markdown, [compressed: 9]))
    end
  end
end
