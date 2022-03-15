defmodule HitsWeb.PageController do
  use HitsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def error(conn, %{"user" => user, "repository" => repository} = params) do
    render(conn, "error.html", user: user, repository: repository)
  end
end
