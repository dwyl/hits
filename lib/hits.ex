defmodule Hits do
  @moduledoc """
  Hits keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @doc """
  svg_badge_template/0 opens the SVG template file.
  the function is single-purpose so that the template is cached.

  returns String of template.
  """
  def svg_badge_template do
    # Want to help optimse this? See: https://github.com/dwyl/hits/issues/70
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
    # stackoverflow.com/a/1084759
    |> String.replace(~r/<!--(.*?)-->/, "")
  end

  @doc """
  get_user_agent_string/1 extracts user-agent, IP address and browser language
  from the Plug.Conn map see: https://hexdocs.pm/plug/Plug.Conn.html

  > there is probably a *much* better way of doing this ... PR v. welcome!

  ## Parameters

  - conn: Map the standard Plug.Conn info see: hexdocs.pm/plug/Plug.Conn.html

  Returns String with user-agent
  """
  def get_user_agent_string(conn) do
    #  TODO: sanitise useragent string https://github.com/dwyl/fields/issues/19
    # extract user-agent from conn.req_headers:
    [{_, ua}] =
      Enum.filter(conn.req_headers, fn {k, _} ->
        k == "user-agent"
      end)

    # IO.inspect(ua, label: "ua")
    ua
  end
end
