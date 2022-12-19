defmodule HitsWeb.Router do
  use HitsWeb, :router

  pipeline :any do
    plug :accepts, ["html", "json"]
    plug Content, %{html_plugs: [
      &fetch_session/2,
      &fetch_flash/2,
      &protect_from_forgery/2,
      &put_secure_browser_headers/2
    ]}
  end

  # temporarily comment out API endpoint till we need it!
  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  scope "/", HitsWeb do
    pipe_through(:any)

    get("/", PageController, :index)
    get("/error/:user/:repository", PageController, :error)

    get("/:user/:repository", HitController, :index)
    get("/:etc/:user/:repository", HitController, :edgecase)
  end

  # Other scopes may use custom stacks.
  # scope "/api", HitsWeb do
  #   pipe_through :api
  # end
end
