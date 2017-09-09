defmodule App.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias App.Router

  @opts Router.init([])

  test "returns homepage" do
    route = conn(:get, "/", "")
    conn = Router.call(route, @opts)

    assert conn.state == :sent
    assert conn.status == 200
  end

  test "GET /favicon.ico returns 301" do
    conn = conn(:get, "/favicon.ico")
    # route = put_req_header(req, )
    conn = Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
  end
  
  test "Request SVG Endpoint returns 200" do
    conn = conn(:get, "/org/" <>
      Integer.to_string(:rand.uniform(1000000)) <> ".svg")
    conn = put_req_header(conn, "user-agent", "Hackintosh")
    conn = put_req_header(conn, "accept-language", "en-GB,en;q=0.5")
    conn = Router.call(conn, @opts)
    # IO.inspect conn.resp_body
    assert conn.resp_body =~ "<text x=\"54\" y=\"14\">1</text>"
    assert conn.state == :sent
    assert conn.status == 200
  end

  test "returns 404" do
    route = conn(:get, "/missing", "")
    conn = Router.call(route, @opts)

    assert conn.state == :sent
    assert conn.status == 404
  end
end
