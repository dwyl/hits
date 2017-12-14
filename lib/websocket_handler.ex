defmodule App.WebsocketHandler do
  @behaviour :cowboy_websocket_handler

  def init(_, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  #Called on websocket connection initialization.
  def websocket_init(_type, req, _opts) do
    state = %{}
    App.WebsocketServer.join(self())
    {:ok, req, state}
  end

  def websocket_handle(message, req, state) do
    IO.puts(message)
    {:ok, req, state}
  end

  def websocket_info({:new_hit, hit}, req, state) do
    {:reply, {:text, hit}, req, state}
  end

  def websocket_info(_info, req, state) do
    {:ok, req, state}
  end

  def websocket_terminate(_reason, _req, _state) do
    App.WebsocketServer.leave(self())
    :ok
  end

end
