defmodule HitsWeb.PageController do
  use HitsWeb, :controller

  def index(conn, _params) do
    conn
    # |>
    |> render("index.html")
  end
end
