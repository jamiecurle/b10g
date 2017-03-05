defmodule B10g.VersionTest do
  use B10g.ModelCase
  alias B10g.Backup
  alias B10g.Factory


  @valid_attrs %{blog: "ºººº"}
  @invalid_attrs %{}

  test "when a post is saved a backup is created" do
      # make user, site and posts
      {:ok, u1} = Factory.create_user(%{email: "b@c.d"})
      {:ok, s1} = Factory.create_site(%{user_id: u1.id})
			{:ok, _p1} = Factory.create_post(%{site_id: s1.id, user_id: u1.id})

      # we have one version
  end

  test "changeset with valid attributes" do
    changeset = Backup.changeset(%Backup{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Backup.changeset(%Backup{}, @invalid_attrs)
    refute changeset.valid?
  end
end
