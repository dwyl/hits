defmodule Example.Router do
  use Plug.Router

  alias Example.Plug.VerifyRequest

  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  plug VerifyRequest, fields: ["content", "mimetype"],
                      paths:  ["/upload"]

  plug :match
  plug :dispatch

  get "/", do: send_resp(conn, 200, "Welcome")
  post "/upload", do: send_resp(conn, 201, "Uploaded\n")
  match _ do 
    IO.inspect conn.path_info
    IO.inspect Enum.join(conn.path_info, "/")
    
    send_resp(conn, 404, Enum.join(conn.path_info, "/"))
  end
end
