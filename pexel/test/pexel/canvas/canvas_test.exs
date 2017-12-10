defmodule Pexel.CanvasTest do
  use Pexel.DataCase

  alias Pexel.Canvas

  describe "tiles" do
    alias Pexel.Canvas.Tile

    @valid_attrs %{"color" => 1, "x" => 42, "y" => 42}
    @update_attrs %{"color" => 2, "x" => 42, "y" => 42}
    @invalid_attrs %{"color" => 18, "x" => 42, "y" => 42}

    def tile_fixture(attrs \\ %{}) do
      {:ok, tile} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Canvas.create_tile()

      tile
    end

    test "list_tiles/0 returns all tiles" do
      tile = tile_fixture()
      assert Canvas.list_tiles() == [tile]
    end

    test "get_tile!/1 returns the tile with given id" do
      tile = tile_fixture()
      assert Canvas.get_tile!(tile.x, tile.y) == tile
    end

    test "create_tile/1 with valid data creates a tile" do
      assert {:ok, %Tile{} = tile} = Canvas.create_tile(@valid_attrs)
      assert tile.color == 1
      assert tile.x == 42
      assert tile.y == 42
    end

    test "create_tile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Canvas.create_tile(@invalid_attrs)
    end

    test "update_tile/2 with valid data updates the tile" do
      tile = tile_fixture()
      assert {:ok, tile} = Canvas.update_tile(tile, @update_attrs)
      assert %Tile{} = tile
      assert tile.color == 2
      assert tile.x == 42
      assert tile.y == 42
    end

    test "update_tile/2 with invalid data returns error changeset" do
      tile = tile_fixture()
      assert {:error, %Ecto.Changeset{}} = Canvas.update_tile(tile, @invalid_attrs)
      assert tile == Canvas.get_tile!(tile.x, tile.y)
    end

    test "delete_tile/1 deletes the tile" do
      tile = tile_fixture()
      assert {:ok, %Tile{}} = Canvas.delete_tile(tile)
      assert_raise Ecto.NoResultsError, fn -> Canvas.get_tile!(tile.x, tile.y) end
    end

    test "change_tile/1 returns a tile changeset" do
      tile = tile_fixture()
      assert %Ecto.Changeset{} = Canvas.change_tile(tile)
    end
  end
end
