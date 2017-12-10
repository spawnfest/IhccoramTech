defmodule PexelWeb.TileController do
  use PexelWeb, :controller

  alias Pexel.Canvas
  alias Pexel.Canvas.Tile

  action_fallback PexelWeb.FallbackController

  def index(conn, _params) do
    tiles = Canvas.list_tiles()
    render(conn, "index.json", tiles: tiles)
  end

  def create(conn, %{"tile" => tile_params}) do
    with {:ok, %Tile{} = tile} <- Canvas.create_tile(tile_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", tile_path(conn, :show, tile))
      |> render("show.json", tile: tile)
    end
  end

  def show(conn, %{"id" => id}) do
    tile = Canvas.get_tile!(id)
    render(conn, "show.json", tile: tile)
  end

  def update(conn, %{"id" => id, "tile" => tile_params}) do
    tile = Canvas.get_tile!(id)

    with {:ok, %Tile{} = tile} <- Canvas.update_tile(tile, tile_params) do
      render(conn, "show.json", tile: tile)
    end
  end

  def delete(conn, %{"id" => id}) do
    tile = Canvas.get_tile!(id)
    with {:ok, %Tile{}} <- Canvas.delete_tile(tile) do
      send_resp(conn, :no_content, "")
    end
  end
end
