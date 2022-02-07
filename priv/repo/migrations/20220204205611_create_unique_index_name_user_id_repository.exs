defmodule Hits.Repo.Migrations.CreateUniqueIndexNameUserIdRepository do
  use Ecto.Migration

  def change do
    create unique_index(:repositories, [:name, :user_id])
  end
end
