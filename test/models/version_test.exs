defmodule B10g.VersionTest do
  use B10g.ModelCase
  alias B10g.Repo
  alias B10g.Version


  @valid_attrs %{markdown: "ºººº"}
  @invalid_attrs %{}

  test "changset automatically casts markdown to term" do
    
    changeset = Version.changeset(%Version{}, @valid_attrs)
    Repo.insert(changeset)
  end

  test "changeset with valid attributes" do
    changeset = Version.changeset(%Version{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Version.changeset(%Version{}, @invalid_attrs)
    refute changeset.valid?
  end
end
