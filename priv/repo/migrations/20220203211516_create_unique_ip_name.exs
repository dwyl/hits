defmodule Hits.Repo.Migrations.CreateUniqueIpName do
  use Ecto.Migration

  def change do
    create unique_index(:useragents, [:name, :ip])
  end
end
