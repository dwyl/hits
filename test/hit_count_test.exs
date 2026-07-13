defmodule HitCountTest do
  use ExUnit.Case
  alias Hits.{HitCount, User, Repository}

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Hits.Repo)
  end

  test "hit_count " do
    user = User.insert(%{"name" => "alex"})
    repo = Ecto.build_assoc(user, :repositories)
    attrs = %{"name" => "totes-amaze"}

    repository = Repository.insert(repo, attrs)
    assert repository.id > 0

    assert HitCount.insert_hit_count(repository.id) == 1
    assert HitCount.insert_hit_count(repository.id) == 2
  end

  # test "insert hit & return hit_count:1" do
  #   badge = Hits.make_badge()
  #   assert badge =~ ~s(flat-square)
  # end

end
