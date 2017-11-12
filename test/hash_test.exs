defmodule HashTest do
  use ExUnit.Case
  alias Poison.Parser, as: JSON

  test "confirm that our hash function works as expected based on fixture" do
    {:ok, json} = fixture()

    Enum.each json,  fn {key, expected} ->
      # IO.puts "#{key} --> #{expected}"
      actual = Hash.make(key, 10)
      assert expected == actual
    end
  end

  defp fixture do
    filename = "./test/hash_fixtures.json"
    {:ok, body} = File.read(filename)
    JSON.parse(body)
  end
end
