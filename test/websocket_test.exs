defmodule App.WebsocketTest do
  use ExUnit.Case
  alias App.WebsocketServer
  alias App.WebsocketHandler
  use Plug.Test

  setup_all do
    port = to_string(Application.get_env(:app, :cowboy_port))
    WebsocketServer.init()
    ws_url = "ws://127.0.0.1:" <> port <> "/ws"

    {:ok, ws_url: ws_url}
  end

  test "websockets connections", state do
    # first websocket join
    ws1 = Socket.connect!(state[:ws_url])
    {:ok, count} = GenServer.call(WebsocketServer, {:clients_count})
    assert count == 1

    # second websocket join
    ws2 = Socket.connect!(state[:ws_url])
    {:ok, count} = GenServer.call(WebsocketServer, {:clients_count})
    assert count == 2

    # verify that 1 client left
    :ok = Socket.Web.close(ws1)
    Process.sleep(1)
    {:ok, count} = GenServer.call(WebsocketServer, {:clients_count})
    assert count == 1

    # verify that there's no more clients
    :ok = Socket.Web.close(ws2)
    Process.sleep(1)
    {:ok, count} = GenServer.call(WebsocketServer, {:clients_count})
    assert count == 0
  end

  test "websockets broadcast", state do
    # first websocket join
    ws1 = Socket.connect!(state[:ws_url])
    {:ok, count} = GenServer.call(WebsocketServer, {:clients_count})
    assert count == 1

    # first broadcast
    WebsocketServer.broadcast("test1")
    {:ok, {:text, response}} = Socket.Web.recv(ws1)
    assert response == "test1"

    # second websocket join
    ws2 = Socket.connect!(state[:ws_url])
    {:ok, count} = GenServer.call(WebsocketServer, {:clients_count})
    assert count == 2

    # second broadcast - both clients should receive
    WebsocketServer.broadcast("test-all")
    {:ok, {:text, response1}} = Socket.Web.recv(ws1)
    {:ok, {:text, response2}} = Socket.Web.recv(ws2)
    assert response1 == "test-all"
    assert response2 == "test-all"
  end

  test "WebsocketHandler functional tests > websocket_info" do
    {res, :req, :state} = WebsocketHandler.websocket_info(:empty, :req, :state)
    assert res == :ok
  end

  test "WebsocketHandler functional tests > websocket_handle" do
    {res, :req, :state} = WebsocketHandler.websocket_handle(:msg, :req, :state)
    assert res == :ok
  end
end
