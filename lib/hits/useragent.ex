defmodule Hits.Useragent do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hits.Repo

  schema "useragents" do
    field(:ip, :string)
    field(:name, :string)

    many_to_many(:repositories, Hits.Repository,
      join_through: Hits.Hit,
      join_keys: [useragent_id: :id, repo_id: :id]
    )

    timestamps()
  end

  @doc false
  def changeset(useragent, attrs \\ %{}) do
    useragent
    |> cast(attrs, [:name, :ip])
    |> validate_required([:name, :ip])
  end

  @doc """
  insert_user_agent/1 inserts and returns the useragent for the request.

  ## Parameters

  - conn: Map the standard Plug.Conn info see: hexdocs.pm/plug/Plug.Conn.html

  returns Int useragent.id
  """
  def insert(attrs) do
    cs =
      %__MODULE__{}
      |> changeset(attrs)

    Repo.insert!(cs,
      on_conflict: [set: [ip: cs.changes.ip, name: cs.changes.name]],
      conflict_target: [:ip, :name]
    )
  end
end
