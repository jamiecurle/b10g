defmodule B10g.AuthControllerTest do
  use B10g.ConnCase
  alias B10g.Factory

  setup %{site: site} do
    B10g.SiteServer.start_link
    url = api_path(@endpoint, :create)
    {:ok, url: url, site: site}
  end

  test "post /api/posts/create creates post", %{url: url, site: site} do
    # make data
    params = %{title: "bar"}


    # the conn
    conn = build_conn()
          |> put_req_header("accept", "application/json")
          |> Map.put(:host, site.cname)
          |> post(url, post: params)

    # we now have one more post
  end
end