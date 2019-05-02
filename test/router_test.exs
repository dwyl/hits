defmodule App.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias App.Router

  @opts Router.init([])

  setup_all do
    log_path = Path.expand("./logs")

    unless File.exists?(log_path) do
      IO.puts("Created Logs Directory: " <> Path.expand("./logs") <> "/agents/")
      File.mkdir_p(Path.expand("./logs") <> "/agents/")
    end

    :ok
  end

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

  test "Request SVG Endpoint returns 200 with current count 1" do
    conn = conn(:get, "/org/" <>
      Integer.to_string(:rand.uniform(1_000_000)) <> ".svg")
    conn = put_req_header(conn, "user-agent", "Hackintosh")
    req = put_req_header(conn, "accept-language", "en-GB,en;q=0.5")
    conn = Router.call(req, @opts)
    assert conn.resp_body =~ ~s(<text x=\"54\" y=\"14\">1</text>)

    assert conn.state == :sent
    assert conn.status == 200

    # Second Call to check Count increased
    conn = Router.call(req, @opts)
    assert conn.resp_body =~ ~s(<text x=\"54\" y=\"14\">2</text>)
  end

  test "returns 404" do
    route = conn(:get, "/missing", "")
    conn = Router.call(route, @opts)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "Confirm User Agent String is Saved to File" do
    conn = conn(:get, "/org/" <>
      Integer.to_string(:rand.uniform(1_000_000)) <> ".svg")
    conn = put_req_header(conn, "user-agent", "Hackintosh")
    req = put_req_header(conn, "accept-language", "en-GB,en;q=0.5")
    conn = Router.call(req, @opts)
    assert conn.state == :sent
    assert conn.status == 200
    # assert conn.resp_body =~ ~s(<text x=\"54\" y=\"14\">1</text>)

    # Make Hash from Connection headers:
    hash = App.Hits.save_user_agent_hash(conn)
    # IO.inspect(hash)
    agent = read_agent_file(hash)
    # IO.inspect(agent)
    assert agent =~ ~s(Hackintosh)
  end

  defp read_agent_file(hash) do
    filename = Path.expand("./logs") <> "/agents/" <> hash
    {:ok, body} = File.read(filename)
    body
  end
end
