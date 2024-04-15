defmodule Hits.MixProject do
  use Mix.Project

  def project do
    [
      app: :hits,
      version: "1.7.1",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        c: :test,
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      package: package(),
      description: "Track page views on any GitHub page"
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
      {:phoenix, "~> 1.7.1"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.11.0"},
      {:postgrex, ">= 0.15.13"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_view, "~> 0.17.5"},
      # Required for Phoenix 1.7
      {:phoenix_view, "~> 2.0"},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:phoenix_live_reload, "~> 1.5.1", only: :dev},
      {:gettext, "~> 0.24.0"},
      {:jason, "~> 1.4.0"},
      {:plug_cowboy, "~> 2.7.0"},
      {:plug_crypto, "~> 2.0.0"},

      # For content negotiation
      {:content, "~> 1.3.0"},

      # Query param schema validation
      {:params, "~> 2.0"},

      # The rest of the dependendencies are for testing/reporting
      # decode .json fixture in test
      {:poison, "~> 5.0.0"},

      # tracking test coverage
      {:excoveralls, "~> 0.18.0", only: [:test, :dev]},
      # to generate documentation
      {:ex_doc, "~> 0.32.1", only: [:dev, :docs]},
      {:inch_ex, "~> 2.1.0-rc.1", only: :docs},
      {:esbuild, "~> 0.8.1", runtime: Mix.env() == :dev}
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
      "assets.deploy": ["esbuild default --minify", "phx.digest"],
      cover: ["coveralls.json"],
      "cover.html": ["coveralls.html"],
      c: ["coveralls.html"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      s: ["phx.server"],
      t: ["test"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  defp package() do
    [
      files: ~w(lib/ LICENSE mix.exs README.md),
      name: "hits",
      licenses: ["GNU GPL v2.0"],
      maintainers: ["dwyl"],
      links: %{"GitHub" => "https://github.com/dwyl/hits"}
    ]
  end
end
