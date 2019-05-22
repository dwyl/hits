defmodule Hits.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Hits.Repo,
      # Start the endpoint when the application starts
      HitsWeb.Endpoint
      # Starts a worker by calling: Hits.Worker.start_link(arg)
      # {Hits.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hits.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  # see: https://hexdocs.pm/phoenix/Phoenix.Endpoint.html#c:config_change/2
  # def config_change(changed, _new, removed) do
  #   HitsWeb.Endpoint.config_change(changed, removed)
  #   :ok
  # end

  # The config_change function is not being used for anything
  # but compilation fails if I remove it ... so this is a "dummy"
  def config_change(_changed, _new, _removed) do
    :ok
  end
end
