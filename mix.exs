# this is a fairly standard/simple mix file ...
defmodule App.Mixfile do
  # if you have *any* questions, ask! :-)
  use Mix.Project

  def project do
    [
      app: :app,
      version: "1.0.0",
      elixir: "~> 1.5",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Configuration for the OTP application
  def application do
    [
      # log any errors independently
      extra_applications: [:logger],
      # supervisor
      mod: {App, []}
    ]
  end

  defp deps do
    # We only need Cowboy & Plug to *run* the app ...
    [
      # the Web Server that runs our Elixir App
      {:cowboy, "~> 1.1.2"},
      # Elixir's HTTP library for routing etc.
      {:plug, "~> 1.3.4"},

      # The rest of the dependendencies are for testing/reporting
      # decode .json fixture in test
      {:poison, "~> 3.1.0"},
      # tracking test coverage
      {:excoveralls, "~> 0.7.0", only: [:test, :dev]},
      # to generate documentation
      {:ex_doc, "~> 0.16.3", only: [:dev]},
      # github.com/rrrene/credo
      {:credo, "~> 0.8.6", only: [:dev, :test]},
      # see: https://git.io/v5inX
      {:inch_ex, "~> 0.5.6", only: :docs},
      {:socket, "~> 0.3"}
    ]
  end

  defp aliases do
    [
      "cover": ["coveralls.json"],
      "cover.html": ["coveralls.html"]
    ]
  end
end
