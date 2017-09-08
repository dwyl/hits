defmodule App.SVGBadgePlug do
  import Plug.Conn

  def init(opts) do 
    opts
  end

  # can we *cache* the SVG template so we aren't opening the file each time?

  def call(conn, opts) do
    conn
    |> put_resp_content_type("image/svg+xml")
    |> send_resp(200, make_badge(42))
    |> halt()
  end
  
  def svg_badge_template() do # help wanted caching this!
    File.read!("./lib/template.svg")
  end
  
  def make_badge(count \\ 1) do
    String.replace(svg_badge_template(), ~r/{count}/, to_string(count))
  end
end
