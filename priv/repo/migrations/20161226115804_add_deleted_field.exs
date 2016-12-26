defmodule B10g.Repo.Migrations.AddDeletedField do
  use Ecto.Migration

  def change do
  	alter table(:posts) do
  	  add :deleted, :boolean
  	end
    create index(:posts, [:deleted])
  end
end
