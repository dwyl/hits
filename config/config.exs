# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :hits,
  ecto_repos: [Hits.Repo]

# Configures the endpoint
config :hits, HitsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "yZWIs7V2AL+ABpoJOjibam5PLvt9UM+BaqEMQvdO0xF3tDgh1/wVLmCVPMq4qn8N",
  render_errors: [view: HitsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Hits.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
