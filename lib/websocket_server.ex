defmodule App.WebsocketServer do
  @moduledoc """
  App.WebsocketServer is a GenServer to interact the
  application with the websockets
  """

  use GenServer
  require Record

  Record.defrecord :state, [clients: []]

  @doc """
  Initialize the GenServer
  """
  def start_link(opts \\ []) do
    :gen_server.start_link({:local, __MODULE__}, __MODULE__, :ok, opts)
  end

  @doc """
  Process utilizes it to join in the server, usually
  called from websockets - cast the `:join` message to GenServer
  """
  def join(pid) do
    :gen_server.cast(__MODULE__, {:join, pid})
  end

  @doc """
  Used by the process when it terminates, called on the websocket
  terminate function - cast the `:leave` message to GenServer
  """
  def leave(pid) do
    :gen_server.cast(__MODULE__, {:leave, pid})
  end

  @doc """
  Broadcast the message to all the websockets clients, or whatsoever processes
  that joined in this GenServer - cast the `:notify_all` message to GenServer
  """
  def broadcast(message) do
    :gen_server.cast(__MODULE__, {:notify_all, message})
  end

  def init(:ok) do
    state = state()
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
    current_clients = state(state, :clients)
    all_clients = [pid | current_clients]
    new_state = state(clients: all_clients)
    {:noreply, new_state}
  end

  def handle_cast({:leave, pid}, state) do
    all_clients = state(state, :clients)
    others = all_clients -- [pid]
    new_state = state(clients: others)
    {:noreply, new_state}
  end

  def handle_cast({:notify_all, message}, state) do
    clients = state(state, :clients)
    Enum.each(clients, &send(&1, {:new_hit, message}))
    {:noreply, state}
  end

end
