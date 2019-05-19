defmodule HitsWeb.HitController do
  use HitsWeb, :controller
  import Ecto.Query
  alias Hits.{Hit, Repository, Repo, User, Useragent}

  def index(conn, %{"user" => user, "repository" => repository } = params) do
    IO.inspect(params, label: "params")
    if repository =~ ".svg" do
      # insert hit
      count = insert_hit(conn, params)
      # render badge
      render_badge(conn, count)

    else
      render(conn, "index.html", params)
    end
  end


  def insert_hit(conn, params) do
    # IO.inspect(params, label: "insert_hit > params")
    useragent_id = insert_user_agent(conn)
    # IO.inspect(useragent_id, label: "useragent_id")
    username = params["user"]
    user_id = insert_user(username)
    # IO.inspect(user_id, label: "user_id")
    repository = params["repository"] |> String.replace(".svg", "")
    repository_id = insert_repository(repository, user_id)
    # IO.inspect(repository_id, label: "repository_id")
    {:ok, hit} = %Hit{repo_id: repository_id, useragent_id: useragent_id}
      |> Hits.Repo.insert()
    # IO.inspect(hit, label: "hit")

    Repo.aggregate(from(h in Hit, # see: github.com/dwyl/hits/issues/71
      where: h.repo_id == ^repository_id), :count, :id)
  end

  @doc """
  insert_user_agent/1 inserts and returns the useragent for the request.

  ## Parameters

  - conn: Map the standard Plug.Conn info see: hexdocs.pm/plug/Plug.Conn.html

  returns Int useragent.id
  """
  def insert_user_agent(conn) do
    # TODO: sanitise useragent string https://github.com/dwyl/fields/issues/19
    # extract user-agent from conn.req_headers:
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
  insert_user/1 inserts and returns the user for the request.

  ## Parameters

  - username: String the user name of the person the repository belongs to.

  returns Int user.id
  """
  def insert_user(username) do
    # TODO: sanitise user string using https://github.com/dwyl/fields/issues/19
    # check if user exists
    case Hits.Repo.get_by(User, name: username) do
      nil  ->  # User not found, insert!
        {:ok, user} =
          %User{name: username}
            |> Hits.Repo.insert()

        IO.inspect(user, label: "INSERTED user:")
        user.id

      user ->
        IO.inspect(user, label: "EXISTING user:")
        user.id
    end
  end

  @doc """
  insert_repository/2 inserts and returns the user for the request.

  ## Parameters

  - repository: String the name of the repository.
  - user_id: Int the user.id the repository belongs to.

  returns Int user.id
  """
  def insert_repository(repository, user_id) do
    # TODO: sanitise repository string using github.com/dwyl/fields/issues/19
    # check if repository exists
    case Hits.Repo.get_by(Repository, name: repository, user_id: user_id) do
      nil  ->  # Repository not found, insert!
        {:ok, repo} =
          %Repository{name: repository, user_id: user_id}
            |> Hits.Repo.insert()

        IO.inspect(repo, label: "INSERTED repo:")
        repo.id

      repo ->
        IO.inspect(repo, label: "EXISTING repo:")
        repo.id
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
