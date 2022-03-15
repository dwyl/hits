defmodule HitsWeb.HitControllerTest do
  use HitsWeb.ConnCase

  # import HitsWeb.HitController

  test "GET /totes/amaze.svg", %{conn: conn} do
    res =
      put_req_header(conn, "user-agent", "Hackintosh")
      |> put_req_header("accept-language", "en-GB,en;q=0.5")
      |> get("/totes/amaze.svg")

    assert res.resp_body =~ Hits.make_badge(1)
  end

  test "GET /user1/repo1.svg", %{conn: conn} do
    res =
      put_req_header(conn, "user-agent", "Hackintosh")
      |> put_req_header("x-forwarded-for", "127.0.0.1, 127.0.0.2")
      |> put_req_header("accept-language", "en-GB,en;q=0.5")
      |> get("/user1/repo1.svg")

    assert res.resp_body =~ Hits.make_badge(1)
  end

  test "test counter increments! GET /totes/amaze.svg", %{conn: conn} do
    put_req_header(conn, "user-agent", "Hackintosh")
    |> put_req_header("accept-language", "en-GB,en;q=0.5")
    |> get("/totes/amaze.svg")

    put_req_header(conn, "user-agent", "Hackintosh1")
    |> put_req_header("accept-language", "en-GB,en;q=0.5")
    |> get("/totes/amaze.svg")

    res3 =
      put_req_header(conn, "user-agent", "Hackintosh2")
      |> put_req_header("accept-language", "en-GB,en;q=0.5")
      |> get("/totes/amaze.svg")

    assert res3.resp_body =~ Hits.make_badge(3)
  end

  test "test counter unique user agent GET /totes/amaze.svg?show=unique", %{conn: conn} do
    put_req_header(conn, "user-agent", "Hackintosh")
    |> put_req_header("accept-language", "en-GB,en;q=0.5")
    |> get("/user/repo.svg?show=unique")

    res =
      put_req_header(conn, "user-agent", "Hackintosh")
      |> put_req_header("accept-language", "en-GB,en;q=0.5")
      |> get("/user/repo.svg?show=unique")

    assert res.resp_body =~ Hits.make_badge(1)
  end

  test "GET /org/dashboard", %{conn: conn} do
    res =
      put_req_header(conn, "user-agent", "Hackintosh")
      |> put_req_header("accept-language", "en-GB,en;q=0.5")
      |> get("/org/dashboard")

    assert res.resp_body =~ ~s(Graphical dashboard coming soon!)
  end

  test "make_badge with default count 1 and style flat-square" do
    badge = Hits.make_badge()
    assert badge =~ ~s(flat-square)
  end

  # URL edgecase github.com/dwyl/hits/issues/67#issuecomment-488970053
  test "GET /hhyo/hhyo/Archery", %{conn: conn} do
    res =
      put_req_header(conn, "user-agent", "Hackintosh")
      |> put_req_header("accept-language", "en-GB,en;q=0.5")
      |> get("/hhyo/hhyo/Archery.svg")

    assert res.resp_body =~ Hits.make_badge(1)
  end

  # edge case where the person forgets to request an .svg file!
  test "GET /test/user/repo-no-svg", %{conn: conn} do
    res =
      put_req_header(conn, "user-agent", "Hackintosh")
      |> put_req_header("accept-language", "en-GB,en;q=0.5")
      |> get("/test/user/repo-no-svg")

    assert res.resp_body =~ ~s(404)
  end

  test "GET /-user/repo.svg invalid user", %{conn: conn} do
    res =
      put_req_header(conn, "user-agent", "Hackintosh")
      |> put_req_header("accept-language", "en-GB,en;q=0.5")
      |> get("/-user/repo.svg")

    assert res.resp_body =~ Hits.svg_invalid_badge()
  end

  test "GET /user/repo{}!!.svg invalid repository", %{conn: conn} do
    res =
      put_req_header(conn, "user-agent", "Hackintosh")
      |> put_req_header("accept-language", "en-GB,en;q=0.5")
      |> get("/user/repo{}!!.svg")

    assert res.resp_body =~ Hits.svg_invalid_badge()
  end
end
