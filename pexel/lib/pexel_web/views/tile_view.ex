defmodule PexelWeb.TileView do
  use PexelWeb, :view
  alias PexelWeb.TileView

  def render("index.json", %{tiles: tiles}) do
    %{data: render_many(tiles, TileView, "tile.json")}
  end

  def render("show.json", %{tile: tile}) do
    %{data: render_one(tile, TileView, "tile.json")}
  end

  def render("tile.json", %{tile: tile}) do
    %{id: tile.id,
      x: tile.x,
      y: tile.y,
      color: tile.color}
  end
end
