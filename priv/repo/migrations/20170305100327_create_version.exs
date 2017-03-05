defmodule B10g.Repo.Migrations.CreateBackup do
  use Ecto.Migration

  def change do
    create table(:versions) do
      add :data, :binary
      add :post_id, references(:posts, on_delete: :nothing)

      timestamps()
    end
    create index(:versions, [:post_id])

  end
end
