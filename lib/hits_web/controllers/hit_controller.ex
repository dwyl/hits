defmodule HitsWeb.HitController do
  use HitsWeb, :controller

  def index(conn, params) do
    IO.inspect(params, label: "params")
    
    render(conn, "index.html", params)
  end
end
