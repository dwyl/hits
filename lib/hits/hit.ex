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
    # IO.inspect(attrs, label: "insert(attrs)")
    attrs |> changeset(%{}) |> Hits.Repo.insert()
    repository_id = attrs.repo_id
    # see: github.com/dwyl/hits/issues/71
    Repo.aggregate(
      from(h in __MODULE__,
        where: h.repo_id == ^repository_id
      ),
      :count,
      :id
    )
  end
end
