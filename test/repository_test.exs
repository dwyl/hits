defmodule RepoTest do
  use ExUnit.Case
  alias Hits.{User, Repository}

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Hits.Repo)
  end

  test "Repository.insert" do
    user_id = User.insert(%User{name: "alex"})
    attrs = %Repository{name: "totes-amaze", user_id: user_id}
    repo_id = Repository.insert(attrs)
    assert repo_id > 0

    # attempting to insert the same repo will simply return the same id:
    repo_id2 = Repository.insert(attrs)
    assert repo_id == repo_id2
  end
end
