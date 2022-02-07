defmodule Hits.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hits.Repo

  schema "users" do
    field(:name, :string)
    has_many(:repositories, Hits.Repository)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  @doc """
  insert/1 inserts and returns the user for the request.

  ## Parameters

  - attrs: Map with the name of the person the repository belongs to.

  returns Int user.id
  """
  def insert(attrs) do
    #  TODO: sanitise user string using github.com/dwyl/fields/issues/19
    cs =
      %__MODULE__{}
      |> changeset(attrs)

    Repo.insert!(cs,
      on_conflict: [set: [name: cs.changes.name]],
      conflict_target: [:name]
    )
  end
end
