defmodule App.Hits do
  @moduledoc """
  App.Hits contains all hits-related helper functions.
  """
  require Hash

  @doc """
  svg_badge_template/0 opens the SVG template file.
  the function is single-purpose so that we can _cache_ the template.
  see: https://github.com/dwyl/hits-elixir/issues/3 #helpwanted

  returns String of template.
  """
  def svg_badge_template do # help wanted caching this!
    File.read!("./lib/template.svg") # see: github.com/dwyl/hits-elixir/issues/3
  end

  @doc """
  make_badge/1 from svg template substituting the count value

  ## Parameters

  - count: Number the view/hit count to be displayed in the badge.

  Returns the badge XML with the count.
  """
  def make_badge(count \\ 1) do
    String.replace(svg_badge_template(), ~r/{count}/, to_string(count))
  end

  @doc """
  get_user_agent_string/1 extracts user-agent, IP address and browser language
  from the Plug.Conn map see: https://hexdocs.pm/plug/Plug.Conn.html

  > there is probably a *much* better way of doing this ... PR v. welcome!

  ## Parameters

  - conn: Map the standard Plug.Conn info see: hexdocs.pm/plug/Plug.Conn.html

  Returns String with user-agent, IP and language separated by "pipe" charater.
  """
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

  @doc """
  save_user_agent_has/1 save/overwrite user-agent in a file
  the filename is the SHA hash of the string so it's always the same.
  from the Plug.Conn map see: https://hexdocs.pm/plug/Plug.Conn.html

  > there is probably a *much* better way of doing this ... PR v. welcome!

  ## Parameters

  - conn: Map the standard Plug.Conn info see: hexdocs.pm/plug/Plug.Conn.html

  Returns String with user-agent, IP and language separated by "pipe" charater.
  """
  def save_user_agent_hash(conn) do
    ua = get_user_agent_string(conn)
    hash = Hash.make(ua, 10)
    agent_path = Path.expand("./logs") <> "/agents/" <> hash
    File.write(agent_path, ua, [:binary])
    hash
  end

  @doc """
  get_hit_count/1 reads the log file for the given file path (if it exists)
  finds the last line in the file and read the hit valie in the last column.

  ## Parameters

  - hit_path: String the filesystem path to the hits append-only log file.

  Returns Number count the current hit count for the given url.
  """
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

  @doc """
  save_hit/1 is the "main" function for saving a hit including extracting
  user-agent data from conn (see above).

  ## Parameters

  - conn: Map the standard Plug.Conn info see: hexdocs.pm/plug/Plug.Conn.html

  Returns Number count the current hit count for the given url.
  """
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
