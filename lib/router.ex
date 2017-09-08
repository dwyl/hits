defmodule App.Router do
  use Plug.Router
  require Hash
  
  plug Plug.Logger
  plug :match
  plug :dispatch

  get "/", do: send_file(conn, 200, "lib/index.html")
  get "/favicon.ico", do: send_file(conn, 200, "lib/favicon.ico")

  match _ do 

    path = conn.path_info
    [last | _] = Enum.take(path, -1) # last part of url path e.g "myproject.svg"
    cond do
      length(String.split(last, ".svg")) > 1 ->
        str = get_user_agent_string(conn)
        hash = Hash.make(str, 10);
        agent_path = Path.expand("./logs") <> "/" <> hash
        # IO.inspect agent_path
        File.write(agent_path, str, [:binary])
        # IO.inspect hash
        render_badge(conn, 42)
      true ->
        IO.inspect conn.path_info
        IO.inspect Enum.join(conn.path_info, "/")
        send_resp(conn, 404, Enum.join(conn.path_info, "/"))  
    end
  end
  
  def render_badge(conn, count) do
    conn
    |> put_resp_content_type("image/svg+xml")
    |> send_resp(200, make_badge(count))
    |> halt()
  end
  
  def svg_badge_template() do # help wanted caching this!
    File.read!("./lib/template.svg")
  end
  
  def make_badge(count \\ 1) do
    String.replace(svg_badge_template(), ~r/{count}/, to_string(count))
  end
  
  # there is probably a *much* better way of doing this ... PR welcome!
  def get_user_agent_string(conn) do
    [{_, ua}] = Enum.filter(conn.req_headers, fn {k, _} -> k == "user-agent" end)
    [{_, lang}] = Enum.filter(conn.req_headers, fn {k, _} -> k == "accept-language" end)
    [lang | _] = Enum.take(String.split(String.upcase(lang), ","), 1)
    ip = Enum.join(Tuple.to_list(conn.remote_ip), ".")
    Enum.join([ua, ip, lang], "|")
  end
  
end
