defmodule App.Mixfile do # this is a fairly standard/simple mix file ...
  use Mix.Project        # if you have *any* questions, ask! :-)

  def project do
    [
      app: :app,
      version: "1.0.0",
      elixir: "~> 1.5",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test,
        "coveralls.post": :test, "coveralls.html": :test]
    ]
  end

  # Configuration for the OTP application
  def application do
    [
      extra_applications: [:logger], # log any errors independently
      mod: {App, []}                    # supervisor
    ]
  end

  defp deps do
    [ # We only need Cowboy & Plug to *run* the app ...
      {:cowboy, "~> 1.1.2"}, # the Web Server that runs our Elixir App
      {:plug, "~> 1.3.4"},   # Elixir's HTTP library for routing etc.

      # The rest of the dependendencies are for testing/reporting
      {:poison, "~> 3.1.0", only: [:test, :dev]}, # decode .json fixture in test
      {:excoveralls, "~> 0.7.0", only: [:test, :dev]}, # tracking test coverage
      {:ex_doc, "~> 0.16.1", only: [:test, :dev]}, # to generate documentation
      {:dogma, "~> 0.1", only: [:test, :dev]}, # Elixir style
      {:inch_ex, only: :docs} # see: github.com/dwyl/repo-badges#documentation
    ]
  end
end
