defmodule B10g.Repo.Migrations.CreateBackup do
  use Ecto.Migration

  def change do
    create table(:backups) do
      add :blog, :binary
      add :post, references(:posts, on_delete: :nothing)

      timestamps()
    end
    create index(:backups, [:post])

  end
end
