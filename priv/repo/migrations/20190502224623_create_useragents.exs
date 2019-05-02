defmodule Hits.Repo.Migrations.CreateUseragents do
  use Ecto.Migration

  def change do
    create table(:useragents) do
      add :name, :string
      add :ip, :string

      timestamps()
    end

  end
end
