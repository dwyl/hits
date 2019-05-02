defmodule Hits.ContextTest do
  use Hits.DataCase

  alias Hits.Context

  describe "hits" do
    alias Hits.Context.Hit

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def hit_fixture(attrs \\ %{}) do
      {:ok, hit} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Context.create_hit()

      hit
    end

    test "list_hits/0 returns all hits" do
      hit = hit_fixture()
      assert Context.list_hits() == [hit]
    end

    test "get_hit!/1 returns the hit with given id" do
      hit = hit_fixture()
      assert Context.get_hit!(hit.id) == hit
    end

    test "create_hit/1 with valid data creates a hit" do
      assert {:ok, %Hit{} = hit} = Context.create_hit(@valid_attrs)
    end

    test "create_hit/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Context.create_hit(@invalid_attrs)
    end

    test "update_hit/2 with valid data updates the hit" do
      hit = hit_fixture()
      assert {:ok, %Hit{} = hit} = Context.update_hit(hit, @update_attrs)
    end

    test "update_hit/2 with invalid data returns error changeset" do
      hit = hit_fixture()
      assert {:error, %Ecto.Changeset{}} = Context.update_hit(hit, @invalid_attrs)
      assert hit == Context.get_hit!(hit.id)
    end

    test "delete_hit/1 deletes the hit" do
      hit = hit_fixture()
      assert {:ok, %Hit{}} = Context.delete_hit(hit)
      assert_raise Ecto.NoResultsError, fn -> Context.get_hit!(hit.id) end
    end

    test "change_hit/1 returns a hit changeset" do
      hit = hit_fixture()
      assert %Ecto.Changeset{} = Context.change_hit(hit)
    end
  end
end
