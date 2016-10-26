defmodule B10g.Repo.Migrations.Posts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :body, :text
      add :slug, :string
      add :markdown, :text
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:posts, [:user_id])
  end
end
