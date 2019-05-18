defmodule HitsWeb.HitController do
  use HitsWeb, :controller
  alias Hits.Useragent

  def index(conn, %{"user" => user, "repository" => repository } = params) do
    IO.inspect(params, label: "params")
    if repository =~ ".svg" do
      # insert hit
      insert_hit(conn, params)

      # render badge
      count = 42
      render_badge(conn, count)

    else
      render(conn, "index.html", params)
    end
  end



  def insert_hit(conn, params) do
    useragent_id = insert_user_agent(conn)
    IO.inspect(useragent_id, label: "useragent_id")

  end

  # does what it says. returns useragent.id
  def insert_user_agent(conn) do
    # extract useragent from conn.req_headers:
    # TODO: sanitise useragent string https://github.com/dwyl/fields/issues/19
    [{_, ua}] = Enum.filter(conn.req_headers, fn {k, _} ->
      k == "user-agent" end)
    IO.inspect(ua, label: "ua")

    # remote_ip comes in as a Tuple {192, 168, 1, 42} >> 192.168.1.42 (dot quad)
    ip = Enum.join(Tuple.to_list(conn.remote_ip), ".")
    IO.inspect(ip, label: "ip")

    # check if useragent exists
    case Hits.Repo.get_by(Useragent, name: ua) do
      nil  ->  # Agent not found, insert!
        {:ok, useragent} =
          %Useragent{name: ua, ip: ip}
            |> Hits.Repo.insert()

        IO.inspect(useragent, label: "INSERTED useragent:")
        useragent.id

      useragent ->
        IO.inspect(useragent, label: "EXISTING useragent:")
        useragent.id
    end

  end

  @doc """
  svg_badge_template/0 opens the SVG template file.
  the function is single-purpose so that we can _cache_ the template.
  see: https://github.com/dwyl/hits-elixir/issues/3 #helpwanted

  returns String of template.
  """
  def svg_badge_template do
    # help wanted caching this! See: https://github.com/dwyl/hits/issues/70
    File.read!("./lib/hits_web/templates/hit/badge.svg")
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
  render_badge/2 renders the badge for the url requested in conn

  ## Parameters

  - conn: Map the standard Plug.Conn info see: hexdocs.pm/plug/Plug.Conn.html
  - count: Number the view/hit count to be displayed in the badge.

  Returns Http response to end-user's browser with the svg (XML) of the badge.
  """
  def render_badge(conn, count) do

    conn
    |> put_resp_content_type("image/svg+xml")
    |> send_resp(200, make_badge(count))
  end
end
