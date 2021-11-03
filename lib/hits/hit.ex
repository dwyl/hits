defmodule Hits.Hit do
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  alias Hits.Repo

  schema "hits" do
    field(:repo_id, :id)
    field(:useragent_id, :id)

    timestamps()
  end

  @doc false
  def changeset(hit, attrs) do
    hit
    |> cast(attrs, [])
    |> validate_required([])
  end

  def insert(attrs) do
    attrs |> changeset(%{}) |> Hits.Repo.insert()
    # see: github.com/dwyl/hits/issues/71
    attrs.repo_id
    |> get_aggregate_query()
    |> Repo.aggregate(:count, :id)
  end

  defp get_aggregate_query(repository_id) do
    from(h in __MODULE__,
      distinct: h.useragent_id,
      where: h.repo_id == ^repository_id
    )
  end
end
