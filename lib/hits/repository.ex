defmodule Hits.Repository do
  use Ecto.Schema
  import Ecto.Changeset

  schema "repositories" do
    field(:name, :string)
    field(:user_id, :id)

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
  def insert(attrs) do
    #  TODO: sanitise user string using github.com/dwyl/fields/issues/19
    # check if user exists
    case Hits.Repo.get_by(__MODULE__, name: attrs.name, user_id: attrs.user_id) do
      # repo not found, insert!
      nil ->
        {:ok, repo} = attrs |> changeset(%{}) |> Hits.Repo.insert()

        # IO.inspect(repo, label: "INSERTED repo:")
        repo.id

      repo ->
        # IO.inspect(repo, label: "EXISTING repo:")
        repo.id
    end
  end
end
