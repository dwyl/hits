defmodule Hits.MixProject do
  use Mix.Project

  def project do
    [
      app: :hits,
      version: "1.0.0",
      elixir: "~> 1.12.3",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Hits.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.1"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_ecto, "~> 4.1.0"},
      {:ecto_sql, "~> 3.4.4"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2.1"},
      {:plug_cowboy, "~> 2.2.1"},

      # The rest of the dependendencies are for testing/reporting
      # decode .json fixture in test
      {:poison, "~> 4.0"},
      # tracking test coverage
      {:excoveralls, "~> 0.13.0", only: [:test, :dev]},
      # to generate documentation
      {:ex_doc, "~> 0.22.1", only: [:dev, :docs]},
      {:inch_ex, "~> 2.0.0", only: :docs}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"],
      cover: ["coveralls.json"],
      "cover.html": ["coveralls.html"]
    ]
  end
end
