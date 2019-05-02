defmodule HitsWeb.HitControllerTest do
  use HitsWeb.ConnCase

  alias Hits.Context

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:hit) do
    {:ok, hit} = Context.create_hit(@create_attrs)
    hit
  end

  describe "index" do
    test "lists all hits", %{conn: conn} do
      conn = get(conn, Routes.hit_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Hits"
    end
  end

  describe "new hit" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.hit_path(conn, :new))
      assert html_response(conn, 200) =~ "New Hit"
    end
  end

  describe "create hit" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.hit_path(conn, :create), hit: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.hit_path(conn, :show, id)

      conn = get(conn, Routes.hit_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Hit"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.hit_path(conn, :create), hit: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Hit"
    end
  end

  describe "edit hit" do
    setup [:create_hit]

    test "renders form for editing chosen hit", %{conn: conn, hit: hit} do
      conn = get(conn, Routes.hit_path(conn, :edit, hit))
      assert html_response(conn, 200) =~ "Edit Hit"
    end
  end

  describe "update hit" do
    setup [:create_hit]

    test "redirects when data is valid", %{conn: conn, hit: hit} do
      conn = put(conn, Routes.hit_path(conn, :update, hit), hit: @update_attrs)
      assert redirected_to(conn) == Routes.hit_path(conn, :show, hit)

      conn = get(conn, Routes.hit_path(conn, :show, hit))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, hit: hit} do
      conn = put(conn, Routes.hit_path(conn, :update, hit), hit: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Hit"
    end
  end

  describe "delete hit" do
    setup [:create_hit]

    test "deletes chosen hit", %{conn: conn, hit: hit} do
      conn = delete(conn, Routes.hit_path(conn, :delete, hit))
      assert redirected_to(conn) == Routes.hit_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.hit_path(conn, :show, hit))
      end
    end
  end

  defp create_hit(_) do
    hit = fixture(:hit)
    {:ok, hit: hit}
  end
end
