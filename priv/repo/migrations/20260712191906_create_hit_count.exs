defmodule Hits.Repo.Migrations.CreateHitCount do
  use Ecto.Migration

  def change do
    create table(:hit_count) do
      add :count, :integer
      add :repo_id, references(:repositories, on_delete: :nothing)

      timestamps()
    end

    create index(:hit_count, [:repo_id])
  end
end
