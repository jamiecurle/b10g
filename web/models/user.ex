defmodule B10g.User do
  use B10g.Web, :model
  use Timex.Ecto.Timestamps

  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hashed, :string
    field :password, :string, virtual: true
    field :apikey, :string
    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
      |> cast(params, [:email, :name])
      |> validate_format(:email, ~r/@/)
      |> put_pass_hash()
  end

  def registration_changeset(model, params \\ %{}) do
    model
      |> changeset(params)
      |> cast(params, [:password, :email])
      |> validate_length(:password, min: 6, max: 100)
      |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hashed, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end

end
