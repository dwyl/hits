defmodule Hits.Context do
  @moduledoc """
  The Context context.
  """

  import Ecto.Query, warn: false
  alias Hits.Repo

  alias Hits.Context.Hit

  @doc """
  Returns the list of hits.

  ## Examples

      iex> list_hits()
      [%Hit{}, ...]

  """
  def list_hits do
    Repo.all(Hit)
  end

  @doc """
  Gets a single hit.

  Raises `Ecto.NoResultsError` if the Hit does not exist.

  ## Examples

      iex> get_hit!(123)
      %Hit{}

      iex> get_hit!(456)
      ** (Ecto.NoResultsError)

  """
  def get_hit!(id), do: Repo.get!(Hit, id)

  @doc """
  Creates a hit.

  ## Examples

      iex> create_hit(%{field: value})
      {:ok, %Hit{}}

      iex> create_hit(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_hit(attrs \\ %{}) do
    %Hit{}
    |> Hit.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a hit.

  ## Examples

      iex> update_hit(hit, %{field: new_value})
      {:ok, %Hit{}}

      iex> update_hit(hit, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_hit(%Hit{} = hit, attrs) do
    hit
    |> Hit.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Hit.

  ## Examples

      iex> delete_hit(hit)
      {:ok, %Hit{}}

      iex> delete_hit(hit)
      {:error, %Ecto.Changeset{}}

  """
  def delete_hit(%Hit{} = hit) do
    Repo.delete(hit)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking hit changes.

  ## Examples

      iex> change_hit(hit)
      %Ecto.Changeset{source: %Hit{}}

  """
  def change_hit(%Hit{} = hit) do
    Hit.changeset(hit, %{})
  end
end
