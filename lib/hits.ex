defmodule Hits do
  @moduledoc """
  Hits keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @doc """
  svg_badge_flat_square_template/0 opens the SVG template file for the flat square style.
  the function is single-purpose so that the template is cached.

  returns String of template.
  """
  def svg_badge_flat_square_template do
    # Want to help optimize this? See: https://github.com/dwyl/hits/issues/70
    File.read!("./lib/hits_web/templates/hit/badge_flat_square.svg")
  end

  @doc """
  svg_badge_flat_template/0 opens the SVG template file for the flat style.
  the function is single-purpose so that the template is cached.

  returns String of template.
  """
  def svg_badge_flat_template do
    # Want to help optimize this? See: https://github.com/dwyl/hits/issues/70
    File.read!("./lib/hits_web/templates/hit/badge_flat.svg")
  end

  @doc """
  make_badge/1 from a given svg template style, substituting the count value. Default style is 'flat-square'

  ## Parameters

  - count: Number the view/hit count to be displayed in the badge.
  - style: The style wanted (can choose between 'flat' and 'flat-square')

  Returns the badge XML with the count.
  """
  def make_badge(count \\ 1, style) do
    case style do
      "flat" ->
        String.replace(svg_badge_flat_template(), ~r/{count}/, to_string(count))
        |> String.replace(~r/<!--(.*?)-->/, "")

      _ ->
        String.replace(svg_badge_flat_square_template(), ~r/{count}/, to_string(count))
        # stackoverflow.com/a/1084759
        |> String.replace(~r/<!--(.*?)-->/, "")
    end


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

    ua
  end
end
