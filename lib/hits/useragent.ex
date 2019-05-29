defmodule Hits.Useragent do
  use Ecto.Schema
  import Ecto.Changeset

  schema "useragents" do
    field(:ip, :string)
    field(:name, :string)

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
    # check if useragent exists by Name && IP Address
    case Hits.Repo.get_by(__MODULE__, name: attrs.name, ip: attrs.ip) do
      # Agent not found, insert!
      nil ->
        {:ok, useragent} = attrs |> changeset(%{}) |> Hits.Repo.insert()

        # IO.inspect(useragent, label: "INSERTED useragent:")
        useragent.id

      useragent ->
        # IO.inspect(useragent, label: "EXISTING useragent:")
        useragent.id
    end
  end
end
