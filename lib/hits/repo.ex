defmodule Hits.Repo do
  use Ecto.Repo,
    otp_app: :hits,
    adapter: Ecto.Adapters.Postgres
end
