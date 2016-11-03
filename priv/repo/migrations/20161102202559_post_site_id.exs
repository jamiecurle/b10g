defmodule B10g.Repo.Migrations.PostSiteId do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :site_id, references(:sites, on_delete: :nothing)
    end
    create index(:posts, [:site_id])
    create index(:posts, [:slug])
  end
end
