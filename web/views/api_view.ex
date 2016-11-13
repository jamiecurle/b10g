defmodule B10g.APIView do
  use B10g.Web, :view

  def render("create.json", %{status: status}) do
    %{status: status}
  end

  def render("errors.json", %{status: status, changeset: changeset}) do

    errors = Ecto.Changeset.traverse_errors(changeset, fn
      {msg, opts} ->
      	String.replace(msg, "%{count}", to_string(opts[:count]))
      msg ->
      	msg
    end)

    %{status: status, errors: errors}

  end


end