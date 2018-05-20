defmodule App.WebsocketServer do
  @moduledoc """
  App.WebsocketServer is a GenServer to interact the
  application with the websockets
  """

  use GenServer

  @doc """
  Initialize the GenServer
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc """
  Process utilizes it to join in the server, usually
  called from websockets - cast the `:join` message to GenServer
  """
  def join(pid) do
    GenServer.cast(__MODULE__, {:join, pid})
  end

  @doc """
  Used by the process when it terminates, called on the websocket
  terminate function - cast the `:leave` message to GenServer
  """
  def leave(pid) do
    GenServer.cast(__MODULE__, {:leave, pid})
  end

  @doc """
  Broadcast the message to all the websockets clients, or whatsoever processes
  that joined in this GenServer - cast the `:notify_all` message to GenServer
  """
  def broadcast(message) do
    GenServer.cast(__MODULE__, {:notify_all, message})
  end

  def init do
    state = []
    {:ok, state}
  end

  def handle_info(_info, state) do
    {:noreply, state}
  end

  def terminate(_reason, _state) do
    :ok
  end

  @doc """
  Handle the cast messages

  `:join` - Insert a new process on the websockets
  clients list

  `:leave` - Removes the current process from
  the websockets clients list

  `:notify_all` cast message - Insert a new process on the websockets
  clients list
  """
  def handle_cast({:join, pid}, state) do
    current_clients = state
    new_state = [pid | current_clients]
    {:noreply, new_state}
  end

  def handle_cast({:leave, pid}, state) do
    all_clients = state
    others = all_clients -- [pid]
    new_state = others
    {:noreply, new_state}
  end

  def handle_cast({:notify_all, message}, state) do
    clients = state
    Enum.each(clients, &send(&1, {:new_hit, message}))
    {:noreply, state}
  end

  def handle_call({:clients_count}, _from, state) do
    {:reply, {:ok, Enum.count(state)}, state}
  end
end
