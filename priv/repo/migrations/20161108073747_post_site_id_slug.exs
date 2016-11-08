defmodule B10g.Repo.Migrations.PostSiteIdSlug do
  use Ecto.Migration

  def change do
		create unique_index(:posts, [:site_id, :slug])

  end
end
