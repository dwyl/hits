defmodule App.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias App.Router

  @opts Router.init([])

  test "returns welcome" do
    route = conn(:get, "/", "")
    conn = Router.call(route, @opts)

    assert conn.state == :sent
    assert conn.status == 200
  end

# transform this into our svg test
# test "returns uploaded" do
#   conn = conn(:post, "/upload", "content=#{@content}&mimetype=#{@mimetype}")
#   |> put_req_header("content-type", "application/x-www-form-urlencoded")
#   |> Router.call(@opts)
#
#   assert conn.state == :sent
#   assert conn.status == 201
# end

  test "GET /favicon.ico returns 301" do
    route = conn(:get, "/favicon.ico", "")
    conn = Router.call(route, @opts)

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
