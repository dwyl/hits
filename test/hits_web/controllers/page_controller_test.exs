defmodule HitsWeb.PageControllerTest do
  use HitsWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Hits!"
  end

  test "GET /--user/repo$", %{conn: conn} do
    conn = get(conn, "/--user/repo$")
    assert html_response(conn, 302)
  end

  test "GET /error/--user/repo$", %{conn: conn} do
    conn = get(conn, "/error/--user/repo$")
    assert html_response(conn, 200) =~ "Validation Error!"
  end
end
