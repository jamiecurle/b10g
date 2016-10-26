defmodule B10g.Repo.Migrations.Users do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :password_hashed, :string
      add :name, :string

      timestamps()
    end
  end
end
