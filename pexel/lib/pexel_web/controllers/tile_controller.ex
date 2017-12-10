defmodule PexelWeb.TileController do
  use PexelWeb, :controller

  alias Pexel.Canvas
  alias Pexel.Canvas.Tile
  alias PexelWeb.CanvasChannel

  action_fallback PexelWeb.FallbackController

  def index(conn, _params) do
    tiles = Canvas.list_tiles()
    render(conn, "index.json", tiles: tiles)
  end

  def create(conn, %{"tile" => tile_params}) do
    with {:ok, %Tile{} = tile} <- Canvas.create_tile(tile_params) do
      CanvasChannel.broadcast_new_tile(tile)

      conn
      |> put_status(:created)
      |> put_resp_header("location", tile_path(conn, :show, tile.x, tile.y))
      |> render("show.json", tile: tile)
    end
  end

  def show(conn, %{"x" => x, "y" => y}) do
    tile = Canvas.get_tile!(x, y)
    render(conn, "show.json", tile: tile)
  end

  def update(conn, %{"x" => x, "y" => y, "tile" => tile_params}) do
    tile = Canvas.get_tile!(x, y)

    with {:ok, %Tile{} = tile} <- Canvas.update_tile(tile, tile_params) do
      CanvasChannel.broadcast_new_tile(tile)

      render(conn, "show.json", tile: tile)
    end
  end

  def delete(conn, %{"x" => x, "y" => y}) do
    tile = Canvas.get_tile!(x, y)
    with {:ok, %Tile{}} <- Canvas.delete_tile(tile) do
      send_resp(conn, :no_content, "")
    end
  end
end
