defmodule App.WebsocketServer do
  use GenServer
  require Record

  Record.defrecord :state, [clients: []]

  def start_link(opts \\ []) do
    :gen_server.start_link({:local, __MODULE__}, __MODULE__, :ok, opts)
  end

  def join(pid) do
    :gen_server.cast(__MODULE__, {:join, pid})
  end

  def leave(pid) do
    :gen_server.cast(__MODULE__, {:leave, pid})
  end

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
