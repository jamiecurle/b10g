defmodule B10g.VersionTest do
  use B10g.ModelCase
  alias B10g.Repo
  alias B10g.Version


  @valid_attrs %{markdown: "ºººº"}
  @invalid_attrs %{}

  test "changset automatically casts markdown to term" do
    # make a post
    {:ok, post} = B10g.Factory.create_post

    # make the data
    data = Map.merge(@valid_attrs, %{post_id: post.id})

    # make the changeset
    changeset = Version.changeset(%Version{}, data)

    # insert the version
    v = Repo.insert!(changeset)

    # we have the version data
    assert v.data == <<131, 109, 0, 0, 0, 8, 194, 186, 194, 186, 194, 186, 194, 186>>
  end

  test "changeset with invalid attributes" do
    changeset = Version.changeset(%Version{}, @invalid_attrs)
    refute changeset.valid?
  end
end
