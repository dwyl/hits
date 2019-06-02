defmodule HitsWeb.HitController do
  use HitsWeb, :controller
  # use Phoenix.Channel
  # import Ecto.Query
  alias Hits.{Hit, Repository, User, Useragent}

  def index(conn, %{"repository" => repository} = params) do
    # IO.inspect(params, label: "params")
    if repository =~ ".svg" do
      # insert hit
      count = insert_hit(conn, params)
      # render badge
      render_badge(conn, count)
    else
      render(conn, "index.html", params)
    end
  end

  @doc """
  insert_hit/2 inserts the hit and other requred records

  ## Parameters

  - conn: Map the standard Plug.Conn info see: hexdocs.pm/plug/Plug.Conn.html
  - params: Struct supplied by router should include respository and user.

  Returns count.
  """
  def insert_hit(conn, params) do
    useragent = Hits.get_user_agent_string(conn)

    # remote_ip comes in as a Tuple {192, 168, 1, 42} >> 192.168.1.42 (dot quad)
    ip = Enum.join(Tuple.to_list(conn.remote_ip), ".")
    # TODO: perform IP Geolocation lookup here so we can insert lat/lon for map!

    # insert the useragent:
    useragent_id = Useragent.insert(%Useragent{name: useragent, ip: ip})

    # extract GitHub username from params so it can be saved & sent via channel:
    username = params["user"]
    # insert the user:
    user_id = User.insert(%User{name: username})

    # strip ".svg" from repo name and insert:
    repository = params["repository"] |> String.split(".svg") |> List.first()

    repository_attrs = %Repository{name: repository, user_id: user_id}
    repository_id = Repository.insert(repository_attrs)

    # insert the hit record:
    hit_attrs = %Hit{repo_id: repository_id, useragent_id: useragent_id}
    count = Hit.insert(hit_attrs)

    # Send hit to connected clients via channel github.com/dwyl/hits/issues/79
    HitsWeb.Endpoint.broadcast("hit:lobby", "hit",
      %{"user" => username, "repo" => repository, "count" => count})

    # return the count for the badge:
    count
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
    |> send_resp(200, Hits.make_badge(count))
  end

  @doc """
  edgecase/2 handles the case where people did not follow the instructions
  for creating their badge ... 🙄  see: https://github.com/dwyl/hits/issues/67

  ## Parameters

  - conn: Map the standard Plug.Conn info see: hexdocs.pm/plug/Plug.Conn.html
  - params: the url path params %{"etc", "user", "repository"}

  Invokes the index function if ".svg" is present else returns "bad badge"
  """
  def edgecase(conn, %{"repository" => repository} = params) do
    # note: we ignore the "etc" portion of the url which is usually
    # just the person's username ... see: github.com/dwyl/hits/issues/67
    # we cannot help you so you get a 404!
    if repository =~ ".svg" do
      index(conn, params)
    else
      conn
      |> put_resp_content_type("image/svg+xml")
      |> send_resp(404, Hits.make_badge(404))
    end
  end
end
