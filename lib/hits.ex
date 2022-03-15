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
    # File.read!("./lib/hits_web/templates/hit/badge_flat_square.svg")
    """
    <?xml version="1.0"?> <!-- SVG container is 80 x 20 pixel rectangle -->
      <svg xmlns="http://www.w3.org/2000/svg" width="80" height="20" id="flat-square">
        <rect width="30" height="20" fill="#555"/> <!-- grey rectangle 30px width -->
        <rect x="30" width="50" height="20" fill="#4c1"/> <!-- green rect 30px -->
        <g fill="#fff" text-anchor="middle" font-size="11"
          font-family="DejaVu Sans,Verdana,Geneva,sans-serif"> <!-- group & font -->
            <text x="15" y="14">hits</text> <!-- "hits" label -->
            <text x="54" y="14">{count}</text>  <!-- count is replaced with number -->
        </g>
      </svg> <!-- that's it! pretty simple, right? :-) Any questions? Ask! -->
    """
  end

  @doc """
  svg_badge_flat_template/0 opens the SVG template file for the flat style.
  the function is single-purpose so that the template is cached.

  returns String of template.
  """
  def svg_badge_flat_template do
    # Want to help optimize this? See: https://github.com/dwyl/hits/issues/70
    # File.read!("./lib/hits_web/templates/hit/badge_flat.svg")
    """
    <?xml version="1.0"?>
    <svg xmlns="http://www.w3.org/2000/svg" width="86" height="20" id="flat">
        <linearGradient id="s" x2="0" y2="100%">
            <stop offset="0" stop-color="#bbb" stop-opacity=".1"/>
            <stop offset="1" stop-opacity=".1"/>
        </linearGradient>
        <clipPath id="r">
            <rect width="86" height="20" rx="3" fill="#fff"/>
        </clipPath>
        <g clip-path="url(#r)">
            <rect width="31" height="20" fill="#555"/>
            <rect x="31" width="55" height="20" fill="#4c1"/>
            <rect width="86" height="20" fill="url(#s)"/>
        </g>
        <g fill="#fff" text-anchor="middle" font-family="Verdana,Geneva,DejaVu Sans,sans-serif"
            font-size="110">
            <text aria-hidden="true" x="165" y="150" fill="#010101" fill-opacity=".3" transform="scale(.1)"
                  textLength="210">hits
            </text>
            <text x="165" y="140" transform="scale(.1)" fill="#fff" textLength="210">hits</text>
            <text aria-hidden="true" x="575" y="150" fill="#010101" fill-opacity=".3" transform="scale(.1)"
                  >{count}
            </text>
            <text x="575" y="140" transform="scale(.1)" fill="#fff" >{count}</text>
        </g>
    </svg>
    """
  end

  def svg_invalid_badge do
    """
    <?xml version="1.0"?>
    <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="96" height="20" role="img" aria-label="hits: invalid url">
      <title>hits: invalid url</title>
      <g shape-rendering="crispEdges"><rect width="31" height="20" fill="#555"/>
        <rect x="31" width="65" height="20" fill="#e05d44"/>
      </g>
      <g fill="#fff" text-anchor="middle" font-family="Verdana,Geneva,DejaVu Sans,sans-serif"
        text-rendering="geometricPrecision" font-size="110">
        <text x="165" y="140" transform="scale(.1)" fill="#fff" textLength="210">hits</text>
        <text x="625" y="140" transform="scale(.1)" fill="#fff" textLength="550">invalid url</text>
      </g>
    </svg>
    """
  end

  @doc """
  make_badge/1 from a given svg template style, substituting the count value. Default style is 'flat-square'

  ## Parameters

  - count: Number the view/hit count to be displayed in the badge.
  - style: The style wanted (can choose between 'flat' and 'flat-square')

  Returns the badge XML with the count.
  """
  def make_badge(count \\ 1, style \\ "") do
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

  def get_user_ip_address(conn) do
    IO.inspect("############ GET IP ADDRESS ##############")
    IO.inspect(conn.req_headers)
    IO.inspect("##########################################")
    Enum.join(Tuple.to_list(conn.remote_ip), ".")
  end
end
