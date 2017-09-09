defmodule App.Hits do
  @moduledoc """
  App.Hits contains all hits-related helper functions.
  """
  require Hash

  # open the SVG template file
  def svg_badge_template do # help wanted caching this!
    File.read!("./lib/template.svg") # see: github.com/dwyl/hits-elixir/issues/3
  end

  # make_badge from svg template substituting the count value
  def make_badge(count \\ 1) do
    String.replace(svg_badge_template(), ~r/{count}/, to_string(count))
  end

  # there is probably a *much* better way of doing this ... PR v. welcome!
  def get_user_agent_string(conn) do
    [{_, ua}] = Enum.filter(conn.req_headers, fn
      {k, _} -> k == "user-agent" end)
    [{_, langs}] = Enum.filter(conn.req_headers,
    fn {k, _} -> k == "accept-language" end)
    [lang | _] = Enum.take(String.split(String.upcase(langs), ","), 1)
    # remote_ip comes in as a Tuple {192, 168, 1, 42} >> 192.168.1.42 (dot quad)
    ip = Enum.join(Tuple.to_list(conn.remote_ip), ".")
    Enum.join([ua, ip, lang], "|")
  end

  # save/overwrite user-agent in a file with the hash as filename
  def save_user_agent_hash(conn) do
    ua = get_user_agent_string(conn)
    hash = Hash.make(ua, 10)
    agent_path = Path.expand("./logs") <> "/agents/" <> hash
    File.write(agent_path, ua, [:binary])
    hash
  end

  # get_hit_count retrieves the hit count for the given url (hit_path)
  def get_hit_count(hit_path) do
    exists = File.regular?(hit_path) # check if existing hits log for url
    count = if exists do
      stream = File.stream!(hit_path)
      [last_line] = stream
        |> Stream.map(&String.trim_trailing/1)
        |> Enum.to_list
        |> Enum.take(-1) # take the last line in the file to get current count

      [i] = Enum.take(String.split(last_line, "|"), -1) # single element list
      {count, _} = Integer.parse(i) # for some reason Int.parse returns tuple...
      count + 1 # increment hit counter
    else
      1 # no previous hits for this url so count is 1
    end
    count
  end

  # save_hit is the "main" function for saving a hit including extracting
  # user-agent data from conn returns count
  def save_hit(conn) do
    path = conn.path_info
    hit_path = Path.expand("./logs") <> "/" <>
      String.replace(Enum.join(path, "_"), ".svg", "") <> ".log"

    count = get_hit_count(hit_path)
    hash = save_user_agent_hash(conn)

    hit = Enum.join([
      Integer.to_string(System.system_time(:millisecond)),
      Enum.join(path, "/"),
      hash,
      count
    ], "|") <> "\n"

    File.write!(hit_path, hit, [:append])
    count
  end
end
