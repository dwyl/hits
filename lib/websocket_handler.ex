defmodule App.WebsocketHandler do
  @moduledoc """
  App.WebsocketHandler is a websocket handler for the Hits messages
  from the server to the clients
  """

  @behaviour :cowboy_websocket_handler

  def init(_, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  @doc """
  Websocket initialization - just handshake and join the WebsocketServer
  """
  def websocket_init(_type, req, _opts) do
    state = %{}
    App.WebsocketServer.join(self())
    {:ok, req, state}
  end

  # Ignore client messages
  def websocket_handle(_message, req, state) do
    {:ok, req, state}
  end

  @doc """
  Sends the Hit data to websocket client
  """
  def websocket_info({:new_hit, hit}, req, state) do
    {:reply, {:text, hit}, req, state}
  end

  # Ignore any unmapped message
  def websocket_info(_info, req, state) do
    {:ok, req, state}
  end

  @doc """
  Websocket termination - just leave the WebsocketServer
  """
  def websocket_terminate(_reason, _req, _state) do
    App.WebsocketServer.leave(self())
    :ok
  end
end
