defmodule FunctionalTests do
  use ExUnit.Case

  test "make_badge with default count 1" do
    badge = App.Hits.make_badge()
    assert badge =~ ~s(1)
  end
end
