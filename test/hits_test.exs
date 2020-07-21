defmodule HitsTest do
  use ExUnit.Case

  test "make_badge with default count 1" do
    badge = Hits.make_badge()
    assert badge =~ ~s(flat-square)
  end

  test "make_badge with default count 1 and flat style" do
    badge = Hits.make_badge(1, "flat")
    assert badge =~ ~s(flat)
    refute badge =~ ~s(flat-square)
  end

  test "make_badge with default count 1 and invalid style" do
    badge = Hits.make_badge(1, "flat")
    assert badge =~ ~s(flat)
    refute badge =~ ~s(flat-square)
  end
end
