defmodule B10g.BackupTest do
  use B10g.ModelCase

  alias B10g.Backup

  @valid_attrs %{blog: "ºººº"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Backup.changeset(%Backup{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Backup.changeset(%Backup{}, @invalid_attrs)
    refute changeset.valid?
  end
end
