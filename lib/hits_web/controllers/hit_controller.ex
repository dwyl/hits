defmodule HitsWeb.HitController do
  use HitsWeb, :controller

  alias Hits.Context
  alias Hits.Context.Hit

  def index(conn, _params) do
    hits = Context.list_hits()
    render(conn, "index.html", hits: hits)
  end

  def switcher(conn, hit_params) do

    IO.inspect(hit_params, label: "hit_params")
    IO.inspect(hit_params["repository"], label: 'hit_params.repository')
    # changeset = Context.change_hit(%Hit{})
    # render(conn, "new.html", changeset: changeset)
    hits = Context.list_hits()
    render(conn, "index.html", hits: hits)
  end

  def insert_or_update_user (conn) do

  end

  # def new(conn, _params) do
  #
  #   changeset = Context.change_hit(%Hit{})
  #   render(conn, "new.html", changeset: changeset)
  # end
  #
  # def create(conn, %{"hit" => hit_params}) do
  #   IO.inspect(hit_params, label: "hit_params")
  #   case Context.create_hit(hit_params) do
  #     {:ok, hit} ->
  #       conn
  #       |> put_flash(:info, "Hit created successfully.")
  #       |> redirect(to: Routes.hit_path(conn, :show, hit))
  #
  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "new.html", changeset: changeset)
  #   end
  # end
  #
  # def show(conn, %{"id" => id}) do
  #   hit = Context.get_hit!(id)
  #   render(conn, "show.html", hit: hit)
  # end
  #
  # def edit(conn, %{"id" => id}) do
  #   hit = Context.get_hit!(id)
  #   changeset = Context.change_hit(hit)
  #   render(conn, "edit.html", hit: hit, changeset: changeset)
  # end
  #
  # def update(conn, %{"id" => id, "hit" => hit_params}) do
  #   hit = Context.get_hit!(id)
  #
  #   case Context.update_hit(hit, hit_params) do
  #     {:ok, hit} ->
  #       conn
  #       |> put_flash(:info, "Hit updated successfully.")
  #       |> redirect(to: Routes.hit_path(conn, :show, hit))
  #
  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "edit.html", hit: hit, changeset: changeset)
  #   end
  # end
  #
  # def delete(conn, %{"id" => id}) do
  #   hit = Context.get_hit!(id)
  #   {:ok, _hit} = Context.delete_hit(hit)
  #
  #   conn
  #   |> put_flash(:info, "Hit deleted successfully.")
  #   |> redirect(to: Routes.hit_path(conn, :index))
  # end
end
