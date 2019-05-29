defmodule CoverageTest do
  use ExUnit.Case
  # use HitsWeb.ConnCase

  # Annoyingly, Phoenix creates a bunch of functions that are not executed
  # during the tests for the app ... this file manually executes them.

  test "invoke config_change (dummy) function" do
    assert Hits.Application.config_change("hello", "world", "!") == :ok
  end
end
