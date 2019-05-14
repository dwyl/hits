defmodule HitsWeb.PageControllerTest do
  use HitsWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Hits!"
  end
end
