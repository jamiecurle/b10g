defmodule B10g.Auth do

  @env Mix.env

  def makepw(pass) when @env == :test do
   :crypto.hash(:md5, pass)
   |> Base.encode16
   |> String.downcase
  end

  def makepw(pass) do
    Comeonin.Bcrypt.hashpwsalt(pass)
  end

  def checkpw(raw, hashed_password) when @env == :test do
    hashed_password == :crypto.hash(:md5, raw)
            |> Base.encode16
            |> String.downcase
  end

  def checkpw(raw, pass) do
    try do
      Comeonin.Bcrypt.checkpw(raw, pass)
    rescue
      MatchError ->
        false
    end
  end

  def dummy_checkpw() when @env == :test do
    false
  end

  def dummy_checkpw() do
    Comeonin.Bcrypt.dummy_checkpw()
  end
end