defmodule B10g.PageView do
  use B10g.Web, :view

  def ui_time(time) do
    case Timex.format(time, "{WDfull} {D} {Mfull} {YYYY} @ {h12}:{m} {AM}") do
      {:ok, string_time} ->
        string_time
      {:error, _ } ->
        "dates are broken"
    end
  end

end
