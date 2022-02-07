defmodule Hits.Repository do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hits.Repo

  schema "repositories" do
    field(:name, :string)
    belongs_to(:user, Hits.User)

    many_to_many(:useragents, Hits.Useragent,
      # see https://elixirforum.com/t/ecto-many-to-many-timestamps/13791
      join_through: Hits.Hit,
      join_keys: [repo_id: :id, useragent_id: :id]
    )

    timestamps()
  end

  @doc false
  def changeset(repository, attrs) do
    repository
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  @doc """
  insert/1 inserts and returns the repository.id.

  ## Parameters

  - attrs: Map with the name of the person the repository belongs to.

  returns Int user.id
  """
  def insert(repository, attrs) do
    #  TODO: sanitise repository string using github.com/dwyl/fields/issues/19
    # check if user exists
    cs = changeset(repository, attrs)

    Repo.insert!(cs,
      on_conflict: [set: [name: cs.changes.name]],
      conflict_target: [:name, :user_id]
    )
  end
end
