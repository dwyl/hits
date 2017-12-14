defmodule App.WebsocketTest do
  use ExUnit.Case
  alias App.WebsocketServer
  alias App.WebsocketHandler

  test "websocket broadcast" do

    # initialize 2 websockets
    WebsocketHandler.websocket_init(nil, "test", nil)
    WebsocketHandler.websocket_init(nil, "test2", nil)

    # broadcast a message
    WebsocketServer.broadcast("new hit!")

    # verify that we have two connected websockets
    {:ok, count} = GenServer.call(WebsocketServer, {:clients_count})
    assert count == 2
  end

end
