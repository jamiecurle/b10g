defmodule B10g.LayoutView do
  use B10g.Web, :view

  def ui_name(name) do
    Enum.map(String.split(name), fn(x)->
      case String.graphemes(x)  do
        [h|t] ->
          "#{h}<span>#{t}</span>"
        _ ->
          x
      end
    end)
  end
end
