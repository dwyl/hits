defmodule HitsWeb.HitController do
  use HitsWeb, :controller
  # use Phoenix.Channel
  # import Ecto.Query
  alias Hits.{Hit, Repository, User, Useragent}

  use Params

  @doc """
  Schema validator.
  The possible URL and query parameters are defined here and checked for validity.
  """
  defparams schema_validator %{
    user!: :string,
    repository!: :string,
    style: :string,
    color: [field: :string, default: "lightgrey"],
    show: :string,
  }

  def index(conn, %{"user" => user, "repository" => repository} = params) do

    # Schema validation
    schema = schema_validator(params)
    params = Params.data(schema)

    if schema.valid? and String.ends_with?(repository, ".svg") do
      if user_valid?(user) and repository_valid?(repository) do
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

        # Render badge or json
        if Content.get_accept_header(conn) =~ "json" do
          render_json(conn)
        else
          render_badge(conn, count, params["style"])
        end
      else
        # Render badge or json
        if Content.get_accept_header(conn) =~ "json" do
          render_invalid_json(conn)
        else
          render_invalid_badge(conn)
        end
      end
    else
      if user_valid?(user) and repository_valid?(repository) do
        render(conn, "index.html", params)
      else
        redirect(conn, to: "/error/#{user}/#{repository}")
      end
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
  render_json/1 outputs an encoded json related to a badge.

  ## Parameters

  - conn: Map the standard Plug.Conn info see: hexdocs.pm/plug/Plug.Conn.html

  Returns an encoded json that can be used with `shields.io` URL.
  See https://shields.io/endpoint
  """
  def render_json(conn) do
    json_response = %{
      "schemaVersion" => "1",
      "label" => "hits",
      "message" => "420",
      "color" => "brightgreen"
    }
    encoded_json = Jason.encode!(json_response)
    json(conn, encoded_json)
  end

  @doc """
  render_invalid_json/1 outputs an encoded json related to an invalid badge.

  ## Parameters

  - conn: Map the standard Plug.Conn info see: hexdocs.pm/plug/Plug.Conn.html

  Returns an encoded json that can be used with `shields.io` URL.
  See https://shields.io/endpoint
  """
  def render_invalid_json(conn) do
    json_response = %{
      "schemaVersion" => "1",
      "label" => "hits",
      "message" => "invalid url",
    }
    encoded_json = Jason.encode!(json_response)
    json(conn, encoded_json)
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

  def render_invalid_badge(conn) do
    conn
    |> put_resp_content_type("image/svg+xml")
    |> send_resp(404, Hits.svg_invalid_badge())
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

  # see issue https://github.com/dwyl/hits/issues/154
  # alphanumeric follow by one or zeor "-" or just alphanumerics
  defp user_valid?(user), do: String.match?(user, ~r/^([[:alnum:]]+-)*[[:alnum:]]+$/)

  #  ^[[:alnum:]-_.]+$ means the name is composed of one or multiple alphanumeric character
  #  or "-_." characters
  defp repository_valid?(repo), do: String.match?(repo, ~r/^[[:alnum:]-_.]+$/)
end
