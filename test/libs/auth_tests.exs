defmodule B10g.AuthTest do
  use B10g.ModelCase
  import B10g.Auth

  test "makepass word works", %{} do
    pw = "househouse"
    assert true == checkpw(pw, makepw(pw))
  end

end