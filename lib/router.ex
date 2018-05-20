defmodule App.Router do
  @moduledoc """
  App.Router is routes all requests to the relevant function.
  """
  use Plug.Router
  # require Hash
  import App.Hits

  # plug Plug.Logger
  plug(:match)
  plug(:dispatch)

  # serve html homepage
  get("/", do: send_file(conn, 200, "lib/index.html"))
  get("/favicon.ico", do: send_file(conn, 200, "lib/favicon.ico"))

  # catch all matcher
  match _ do
    cond do
      # if url includes ".svg"
      conn.request_path =~ ".svg" ->
        render_badge(conn)

      # cath all non .svg requests
      true ->
        send_resp(conn, 404, Enum.join(conn.path_info, "/"))
    end
  end

  @doc """
  render_badge/1 renders the badge for the url requested in conn

  ## Parameters

  - conn: Map the standard Plug.Conn info see: hexdocs.pm/plug/Plug.Conn.html

  Returns Http response to end-user's browser with the svg (XML) of the badge.
  """
  def render_badge(conn) do
    count = save_hit(conn)

    conn
    |> put_resp_content_type("image/svg+xml")
    |> send_resp(200, make_badge(count))
  end
end
