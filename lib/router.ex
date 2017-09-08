defmodule App.Router do
  use Plug.Router
  
  plug Plug.Logger
  plug :match
  plug :dispatch

  get "/", do: send_file(conn, 200, "lib/index.html")
  get "/favicon.ico", do: send_file(conn, 200, "lib/favicon.ico")

  match _ do 
    path = conn.path_info
    [last | _] = Enum.take(path, -1)
    cond do
      length(String.split(last, ".svg")) > 1 ->
        render_badge(conn)
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
  
  def render_badge(conn) do
    conn
    |> put_resp_content_type("image/svg+xml")
    |> send_resp(200, make_badge(42))
    |> halt()
  end
  
  def svg_badge_template() do # help wanted caching this!
    File.read!("./lib/template.svg")
  end
  
  def make_badge(count \\ 1) do
    String.replace(svg_badge_template(), ~r/{count}/, to_string(count))
  end
  
end
