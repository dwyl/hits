defmodule Hits.Repo.Migrations.CreateHits do
  use Ecto.Migration

  def change do
    create table(:hits) do
      add :repo_id, references(:repositories, on_delete: :nothing)
      add :useragent_id, references(:useragents, on_delete: :nothing)

      timestamps()
    end

    create index(:hits, [:repo_id])
    create index(:hits, [:useragent_id])
  end
end
