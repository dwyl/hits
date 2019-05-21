defmodule HitsWeb.HitControllerTest do
  use HitsWeb.ConnCase
  # import HitsWeb.HitController

  test "GET /totes/amaze.svg", %{conn: conn} do
    res = put_req_header(conn, "user-agent", "Hackintosh")
     |> put_req_header("accept-language", "en-GB,en;q=0.5")
     |> get("/totes/amaze.svg")

    # IO.inspect(res.resp_body, label: "res.body")
    assert res.resp_body =~ ~s(1)
  end

  test "test counter increments! GET /totes/amaze.svg", %{conn: conn} do
    res = put_req_header(conn, "user-agent", "Hackintosh")
     |> put_req_header("accept-language", "en-GB,en;q=0.5")
     |> get("/totes/amaze.svg")

    # IO.inspect(res.resp_body, label: "res.body")
    assert res.resp_body =~ ~s(2)
  end

  test "GET /org/dashboard", %{conn: conn} do
    res = put_req_header(conn, "user-agent", "Hackintosh")
     |> put_req_header("accept-language", "en-GB,en;q=0.5")
     |> get("/org/dashboard")

    # IO.inspect(res.resp_body, label: "res.body")
    assert res.resp_body =~ ~s(Graphical dashboard coming soon!)
  end

  test "make_badge with default count 1" do
    badge = Hits.make_badge()
    # |> IO.inspect(label: "badge")
    assert badge =~ ~s(1)
  end
end
