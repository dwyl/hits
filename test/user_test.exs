defmodule UserTest do
  use ExUnit.Case
  alias Hits.User

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Hits.Repo)
  end

  test "User.insert" do
    attrs = %User{name: "jimmy"}
    user_id = User.insert(attrs)
    assert user_id > 0

    # attempting to insert the same user will simply return the same id:
    user_id2 = User.insert(attrs)
    assert user_id == user_id2
  end
end
