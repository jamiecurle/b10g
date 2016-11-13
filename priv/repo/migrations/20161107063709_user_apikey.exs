defmodule B10g.Repo.Migrations.UserApikey do
  use Ecto.Migration

  def change do
  	alter table(:users) do
  	  add :apikey, :string
  	end
    create index(:users, [:apikey])
  end
end
