defmodule App.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/", do: send_file(conn, 200, "lib/index.html")
  get "/favicon.ico", do: send_file(conn, 200, "lib/favicon.ico")
  
  # get "/favicon.ico" do 
  #   
  #   send_resp(conn, 301,  "http://i.imgur.com/zBEQq4w.png")
  # end

  match _ do 
    path = conn.path_info
    cond do
      # Enum.member?(path, "favicon.ico") ->
      #   IO.puts "FAVICON!"
      # 
      # Enum.member?(path, "favicon.ico") ->
      #   IO.puts "FAVICON!"
      #   reply = put_resp_content_type(conn, "image/x-icon")
      #   send_file(reply, 200, "lib/favicon.ico")
      true ->
        IO.inspect conn.path_info
        IO.inspect Enum.join(conn.path_info, "/")
        send_resp(conn, 404, Enum.join(conn.path_info, "/"))  
    end
  end
end
