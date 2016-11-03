defmodule B10g.Repo.Migrations.PostStatusEnum do
  use Ecto.Migration

  def change do
    execute """
        CREATE TYPE post_status_enum
        AS ENUM (
        'DRAFT',
        'PUBLISHED')
      """
    execute """
      ALTER TABLE posts
      ALTER COLUMN status TYPE post_status_enum
      USING status::post_status_enum;
    """
  end
end
