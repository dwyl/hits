defmodule Hits.ValidateTest do
  use ExUnit.Case, async: true
  alias Hits.Validate

  test "user_valid?/1 returns true if the string is a valid GitHub username" do
    user = "pink-fluffy-unicorns-123"
    # dbg(user)
    assert Validate.user_valid?(user) == true
    assert Validate.user_valid?("c@t") == false
  end

  test "repository_valid?/1 returns true if a string is a valid GitHub repo" do
    repo = "pink-fluffy-unicorns_123"
    # dbg(repo)
    assert Validate.repository_valid?(repo) == true
    assert Validate.repository_valid?("c@t") == false
  end
end
