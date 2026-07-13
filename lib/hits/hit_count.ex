defmodule Hits.HitCount do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Hits.{Repo, HitCount}

  schema "hit_count" do
    field :count, :integer
    field :repo_id, :id

    timestamps()
  end

  @doc false
  def changeset(hit_count, attrs) do
    hit_count
    |> cast(attrs, [:repo_id, :count, :id])
    |> validate_required([:repo_id, :count])
  end

  @doc """
  insert_hit_count/1 inserts and returns the hit_count.count integer.

  ## Parameters

  repo_id: 123

  returns Int hit_count.count
  """
  def insert_hit_count(repo_id) do
    current_count = get_hit_count(repo_id)

    {:ok, result } = if current_count == 0 do
      %__MODULE__{}
      |> changeset(%{repo_id: repo_id, count: current_count + 1})
      |> Repo.insert()
    else
      get_hit_count_record(repo_id)
      |> change(count: current_count + 1)
      |> Repo.update()
    end
    result.count
  end

  # Returns just the hit_count.count integer value
  defp get_hit_count(repo_id) do
    count = from(h in HitCount,
      where: h.repo_id == ^repo_id,
      select: h.count
    )
    |> Repo.one()

    if count == nil, do: 0, else: count
  end

  # Returns the whole hit_count record
  defp get_hit_count_record(repo_id) do
    HitCount
    |> where(repo_id: ^repo_id)
    |> Repo.one!()
  end
end
