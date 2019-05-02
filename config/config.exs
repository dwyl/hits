# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :pre_commit, commands: ["credo", "coveralls"]
config :app, cowboy_port: 8080
