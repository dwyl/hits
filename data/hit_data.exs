alias Hits.Repo
alias Hits.{User, Useragent, Repository}

useragent = Useragent.insert(%{"ip" => "127.0.0.1", "name" => "Firefox"})

user = User.insert(%{"name" => "Simon"})

repo = Ecto.build_assoc(user, :repositories)

# This doesn't insset the hit in the table, so not sure the build_assoc works here.
# repo2 =
#   Ecto.build_assoc(useragent, :repositories, repo)
#   |> Repository.insert(%{"name" => "repobuildassoc"})

# repo1 =
#   Ecto.build_assoc(user, :repositories)
#   |> Ecto.Changeset.change()
#   |> Ecto.Changeset.put_assoc(:useragents, [useragent])
#   |> Repository.insert(%{"name" => "repo1"})

# repo2 =
#   Ecto.build_assoc(user, :repositories)
#   |> Ecto.Changeset.change()
#   |> Ecto.Changeset.put_assoc(:useragents, [useragent])
#   |> Repository.insert(%{"name" => "repo2"})

# get unique useagents hit on the repo id 2
# Hits.Repo.get!(Hits.Repository, 2) |> Hits.Repo.preload([useragents: (from u in Hits.Useragent, distinct: u.id)])
