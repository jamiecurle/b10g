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
  end


	# TODO: return false if password not in params
	# this does not seem to be happenenings
  def registration_changeset(model, params \\ %{}) do
    model
      |> changeset(params)
      |> put_apikey()
      |> validate_length(:password, min: 6, max: 100)
      |> cast(params, [:password, :email, :apikey])
      |> put_pass_hash()

  end

	defp put_apikey(changeset) do
		case Map.get(changeset.params, :apikey) do
		  nil ->
				key = :crypto.hash(:md5, "#{:rand.uniform}")|> Base.encode16 |> String.downcase
		  	put_change(changeset, :apikey,  key )
		  apikey ->
		  	changeset
		end
	end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hashed, :crypto.hash(:md5, pass) |> Base.encode16 |> String.downcase)
        # put_change(changeset, :password_hashed, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end

end
