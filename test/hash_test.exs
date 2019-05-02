defmodule HashTest do
  use ExUnit.Case
  alias Poison.Parser, as: JSON

  test "confirm that our hash function works as expected based on fixture" do
    {:ok, json} = fixture()

    Enum.each(json, fn {key, expected} ->
      # IO.puts "#{key} --> #{expected}"
      actual = Hash.make(key, 10)
      assert expected == actual
    end)
  end

  test "Hash.make default length 13" do
    text = "Everything is Awesome!"
    actual = Hash.make(text)
    expected = "Bc6HaSgCH8JKF"
    assert expected == actual
    assert String.length(actual) == 13
  end

  defp fixture do
    filename = "./test/hash_fixtures.json"
    {:ok, body} = File.read(filename)
    JSON.parse(body)
  end
end
