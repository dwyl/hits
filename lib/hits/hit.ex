defmodule Hits.Hit do
  use Ecto.Schema
  import Ecto.Query
  alias Hits.Repo

  schema "hits" do
    belongs_to(:repo, Hits.Repository)
    belongs_to(:useragent, Hits.Useragent)

    timestamps()
  end

  def count_unique_hits(repository_id) do
    # see: github.com/dwyl/hits/issues/71
    repository_id
    |> get_aggregate_query_unique_hits()
    |> Repo.aggregate(:count, :id)
  end

  def count_hits(repository_id) do
    repository_id
    |> get_aggregate_query()
    |> Repo.aggregate(:count, :id)
  end

  defp get_aggregate_query_unique_hits(repository_id) do
    from(h in __MODULE__,
      distinct: h.useragent_id,
      where: h.repo_id == ^repository_id
    )
  end

  defp get_aggregate_query(repository_id) do
    from(h in __MODULE__,
      where: h.repo_id == ^repository_id
    )
  end
end
