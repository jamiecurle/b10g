defmodule B10g.Repo.Migrations.PostStatusEnum do
  use Ecto.Migration

  def up do
    execute """
      ALTER TABLE posts
      ADD COLUMN `status` enum('DRAFT', 'PUBLISHED');
    """
  end

  def down do
  end
end
