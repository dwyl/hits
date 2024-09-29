import Config

# Configure your database
config :hits, Hits.Repo,
  username: "postgres",
  password: "postgres",
  database: "hits_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :hits, HitsWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# https://gist.github.com/chrismccord/2ab350f154235ad4a4d0f4de6decba7b#gistcomment-3944918
# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
