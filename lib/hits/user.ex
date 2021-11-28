defmodule Hits.User do
  use Ecto.Schema
  import Ecto.Changeset

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
    # check if user exists
    case Hits.Repo.get_by(__MODULE__, name: attrs.name) do
      # User not found, insert!
      nil ->
        {:ok, user} = attrs |> changeset(%{}) |> Hits.Repo.insert()

        user.id

      user ->
        user.id
    end
  end
end
