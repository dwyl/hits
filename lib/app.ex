defmodule App do
  @moduledoc """
  The "App" merely starts the Plug Router in a Supervision Tree.
  """
  use Application
  require Logger
  alias App.Router, as: Router # credo requires this ... kinda pointless here.

  def start(_type, _args) do
    port = Application.get_env(:app, :cowboy_port, 8080)

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Router, [], port: port)
    ]

    Logger.info("Started application on port: #{port}")

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
