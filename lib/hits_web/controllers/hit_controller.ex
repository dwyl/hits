defmodule HitsWeb.HitController do
  use HitsWeb, :controller
  import Ecto.Query
  alias Hits.{Hit, Repository, Repo, User, Useragent}

  def index(conn, %{"user" => user, "repository" => repository } = params) do
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


  def insert_hit(conn, params) do
    # IO.inspect(params, label: "insert_hit > params")
    useragent = Hits.get_user_agent_string(conn)
    # remote_ip comes in as a Tuple {192, 168, 1, 42} >> 192.168.1.42 (dot quad)
    ip = Enum.join(Tuple.to_list(conn.remote_ip), ".")
    # IO.inspect(ip, label: "ip")
    useragent_id = Useragent.insert(%Useragent{name: useragent, ip: ip})
    # IO.inspect(useragent_id, label: "useragent_id")
    user_id = User.insert(%User{name: params["user"]})
    # IO.inspect(user_id, label: "user_id")
    repository = params["repository"] |> String.replace(".svg", "")
    repository_attrs = %Repository{name: repository, user_id: user_id}
    repository_id = Repository.insert(repository_attrs)
    # IO.inspect(repository_id, label: "repository_id")

    hit = %Hit{repo_id: repository_id, useragent_id: useragent_id}
    |> IO.inspect(label: "hit Map")
    # changeset = hit.changeset(hit, hit)
    {:ok, hit} = Hits.Repo.insert(hit)
    IO.inspect(hit, label: "hit")

    Repo.aggregate(from(h in Hit, # see: github.com/dwyl/hits/issues/71
      where: h.repo_id == ^repository_id), :count, :id)
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
end
