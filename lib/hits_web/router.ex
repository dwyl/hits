defmodule HitsWeb.Router do
  use HitsWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  # temporarily comment out API endpoint till we need it!
  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  scope "/", HitsWeb do
    pipe_through(:browser)

    get("/", PageController, :index)

    get("/:user/:repository", HitController, :index)
    get("/:etc/:user/:repository", HitController, :edgecase)
  end

  # Other scopes may use custom stacks.
  # scope "/api", HitsWeb do
  #   pipe_through :api
  # end
end
