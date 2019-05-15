defmodule Hits.Hit do
  use Ecto.Schema
  import Ecto.Changeset

  schema "hits" do
    field :repo_id, :id
    field :useragent_id, :id

    timestamps()
  end

  @doc false
  def changeset(hit, attrs) do
    hit
    |> cast(attrs, [])
    |> validate_required([])
  end
end
