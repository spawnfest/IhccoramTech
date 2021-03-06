defmodule Pexel.Canvas do
  @moduledoc """
  The Canvas context.
  """

  import Ecto.Query, warn: false
  alias Pexel.Repo

  alias Pexel.Canvas.Tile

  @side_size 100

  @doc """
  Returns the size of the side of the canvas
  (i.e. how many tiles per side are there).

  For now, the canvas is assumed to be square.
  """
  def side_size do
    @side_size
  end

  @doc """
  Returns the list of tiles.

  ## Examples

      iex> list_tiles()
      [%Tile{}, ...]

  """
  def list_tiles do
    Repo.all(Tile)
  end

  @doc """
  Gets a single tile.

  Raises `Ecto.NoResultsError` if the Tile does not exist.

  ## Examples

      iex> get_tile!(123)
      %Tile{}

      iex> get_tile!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tile!(x, y) do
    Repo.get_by!(Tile, x: x, y: y)
  end

  @doc """
  Creates a tile.

  ## Examples

      iex> create_tile(%{field: value})
      {:ok, %Tile{}}

      iex> create_tile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tile(%{"x" => x, "y" => y} = attrs) do
    tile =
      case Repo.get_by(Tile, x: x, y: y) do
        nil -> %Tile{}
        existing -> existing
      end

    tile
    |> Tile.changeset(attrs)
    |> Repo.insert_or_update()
  end

  @doc """
  Updates a tile.

  ## Examples

      iex> update_tile(tile, %{field: new_value})
      {:ok, %Tile{}}

      iex> update_tile(tile, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tile(%Tile{} = tile, attrs) do
    tile
    |> Tile.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Tile.

  ## Examples

      iex> delete_tile(tile)
      {:ok, %Tile{}}

      iex> delete_tile(tile)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tile(%Tile{} = tile) do
    Repo.delete(tile)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tile changes.

  ## Examples

      iex> change_tile(tile)
      %Ecto.Changeset{source: %Tile{}}

  """
  def change_tile(%Tile{} = tile) do
    Tile.changeset(tile, %{})
  end
end
