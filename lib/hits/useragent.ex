defmodule Hits.Useragent do
  use Ecto.Schema
  import Ecto.Changeset

  schema "useragents" do
    field :ip, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(useragent, attrs) do
    useragent
    |> cast(attrs, [:name, :ip])
    |> validate_required([:name, :ip])
  end
end
