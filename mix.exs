defmodule App.Mixfile do # this is a fairly standard/simple mix file ...
  use Mix.Project        # if you have *any* questions, ask! :-)

  def project do
    [
      app: :app,
      version: "1.0.0",
      elixir: "~> 1.5",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application
  def application do
    [
      # applications: [:poison],
      extra_applications: [:logger], # log any errors independently
      mod: {App, []}                    # supervisor
    ]
  end

  defp deps do
    [
      {:cowboy, "~> 1.1.2"}, # the Web Server that runs our Elixir App
      {:plug, "~> 1.3.4"},   # Elixir's HTTP library for routing etc.
      {:poison, "~> 3.1"}, # to decode .json file in hash test
      {:json, "~> 1.0", only: :dev}, # for reading JSON fixture file
      {:excoveralls, "~> 0.6.2", only: :dev}, # tracking test coverage
      {:ex_doc, "~> 0.11", only: :dev}, # to generate documentation
      {:dogma, "~> 0.1", only: :dev}, # Elixir style
    ]
  end
end
