defmodule B10g.Repo.Migrations.Sites do
  use Ecto.Migration

  def change do
    create table(:sites) do
      add :cname, :string
      add :config, :map
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:sites, [:user_id])
  end
end
