defmodule HitsWeb.HitController do
  use HitsWeb, :controller
  # use Phoenix.Channel
  # import Ecto.Query
  alias Hits.{Hit, Repository, User, Useragent}

  def index(conn, %{"user" => user, "repository" => repository} = params) do
    if String.ends_with?(repository, ".svg") do
      # insert hit
      {_user_schema, _useragent_schema, repo} = insert_hit(conn, user, repository)

      count =
        if params["show"] == "unique" do
          Hit.count_unique_hits(repo.id)
        else
          Hit.count_hits(repo.id)
        end

      # Send hit to connected clients via channel github.com/dwyl/hits/issues/79
      HitsWeb.Endpoint.broadcast("hit:lobby", "hit", %{
        "user" => user,
        "repo" => repository,
        "count" => count
      })

      # render badge
      render_badge(conn, count, params["style"])
    else
      render(conn, "index.html", params)
    end
  end

  @doc """
  insert_hit/3 inserts user, useragent, repository and the
  hit entry which link the useragent to the repository

  ## Parameters

  - conn: Map the standard Plug.Conn info see: hexdocs.pm/plug/Plug.Conn.html
  - username: The Github user
  - repository: The Github repository
  - filter_count: define filter for count result

  Returns tuple {user, useragent, repository}.
  """
  def insert_hit(conn, username, repository) do
    useragent = Hits.get_user_agent_string(conn)

    # remote_ip comes in as a Tuple {192, 168, 1, 42} >> 192.168.1.42 (dot quad)
    ip = Hits.get_user_ip_address(conn)
    # TODO: perform IP Geolocation lookup here so we can insert lat/lon for map!

    # insert the useragent:
    useragent = Useragent.insert(%{"name" => useragent, "ip" => ip})

    # insert the user:
    user = User.insert(%{"name" => username})

    # strip ".svg" from repo name and insert:
    repository_name = repository |> String.split(".svg") |> List.first()

    repository =
      Ecto.build_assoc(user, :repositories)
      |> Ecto.Changeset.change()
      # link useragent to repository to create hit entry
      |> Ecto.Changeset.put_assoc(:useragents, [useragent])
      |> Repository.insert(%{"name" => repository_name})

    {user, useragent, repository}
  end

  @doc """
  render_badge/2 renders the badge for the url requested in conn

  ## Parameters

  - conn: Map the standard Plug.Conn info see: hexdocs.pm/plug/Plug.Conn.html
  - count: Number the view/hit count to be displayed in the badge.

  Returns Http response to end-user's browser with the svg (XML) of the badge.
  """
  def render_badge(conn, count, style) do
    conn
    |> put_resp_content_type("image/svg+xml")
    |> send_resp(200, Hits.make_badge(count, style))
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
      |> send_resp(404, Hits.make_badge(404, params["style"]))
    end
  end
end
