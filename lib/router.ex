defmodule App.Router do
  use Plug.Router
  require Hash
  
  plug Plug.Logger
  plug :match
  plug :dispatch

  get "/", do: send_file(conn, 200, "lib/index.html") # serve html homepage
  get "/favicon.ico", do: send_file(conn, 200, "lib/favicon.ico")

  match _ do  # catch all matcher
    [last | _] = Enum.take(conn.path_info, -1) # last part of url path e.g "myproject.svg"
    cond do
      length(String.split(last, ".svg")) > 1 -> # if url includes ".svg"
        render_badge(conn)
      true -> # cath all non .svg requests
        send_resp(conn, 404, Enum.join(conn.path_info, "/"))  
    end
  end
  
  def render_badge(conn) do
    count = save_hit(conn)
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
  
  # there is probably a *much* better way of doing this ... PR v. welcome!
  def get_user_agent_string(conn) do
    [{_, ua}] = Enum.filter(conn.req_headers, fn {k, _} -> k == "user-agent" end)
    [{_, langs}] = Enum.filter(conn.req_headers, fn {k, _} -> k == "accept-language" end)
    [lang | _] = Enum.take(String.split(String.upcase(langs), ","), 1)
    ip = Enum.join(Tuple.to_list(conn.remote_ip), ".")
    Enum.join([ua, ip, lang], "|")
  end
  
  def save_user_agent_hash(conn) do
    ua = get_user_agent_string(conn)
    hash = Hash.make(ua, 10);
    agent_path = Path.expand("./logs") <> "/" <> hash
    File.write(agent_path, ua, [:binary])
    hash
  end
  
  def get_hit_count(hit_path) do
    exists = File.regular?(hit_path) # check if existing hits log for url
    count = if exists do
      [last_line] = File.stream!(hit_path) 
        |> Stream.map(&String.trim_trailing/1) 
        |> Enum.to_list
        |> Enum.take(-1)
        
      [i] = Enum.take(String.split(last_line, "|"), -1) # single element list
      {count, _} = Integer.parse(i)
      count + 1 # increment hit counter
    else
      1 # no previous hits for this url so count is 1
    end
    count
  end
  
  def save_hit(conn) do
    path = conn.path_info
    hit_path = Path.expand("./logs") <> "/" <> 
      String.replace(Enum.join(path, "_"), ".svg", "") <> ".log"
    
    count = get_hit_count(hit_path)
    hash = save_user_agent_hash(conn)
    
    hit = Enum.join([ 
      Integer.to_string(:os.system_time(:millisecond)),
      Enum.join(path, "/"),
      hash,
      count
    ], "|") <> "\n"

    File.write!(hit_path, hit, [:append])
    count
  end
end
