defmodule App.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/", do: send_resp(conn, 200, "Welcome")

  match _ do 
    IO.inspect conn.path_info
    IO.inspect Enum.join(conn.path_info, "/")
    send_resp(conn, 404, Enum.join(conn.path_info, "/"))
  end
end
