defmodule RepoTest do
  use ExUnit.Case
  alias Hits.{User, Repository}

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Hits.Repo)
  end

  test "Repository.insert" do
    user = User.insert(%{"name" => "alex"})
    repo = Ecto.build_assoc(user, :repositories)
    attrs = %{"name" => "totes-amaze"}

    repository = Repository.insert(repo, attrs)
    assert repository.id > 0

    # attempting to insert the same repo will simply return the same id:
    repository2 = Repository.insert(repo, attrs)
    assert repository == repository2
  end
end
