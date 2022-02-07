# Create dummy data to help while creating the Ecto queries

alias Hits.Repo

useragents = [
  %{
    ip: "127.0.0.1",
    name: "Firefox",
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  }
  # After adding the migration for unique_index on ip and name
  # This map won't be able to be created in Postgres as it is already saved
  # %{
  #   ip: "127.0.0.1",
  #   name: "Firefox",
  #   inserted_at: DateTime.utc_now(),
  #   updated_at: DateTime.utc_now()
  # }
]

Repo.insert_all("useragents", useragents)
