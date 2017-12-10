defmodule PexelWeb.CanvasChannel do
  use PexelWeb, :channel

  alias Pexel.Canvas.Tile

  def join("canvas:updates", _payload, socket) do
    {:ok, socket}
  end

  def broadcast_new_tile(%Tile{x: x, y: y, color: color}) do
    payload = %{x: x, y: y, color: color}

    PexelWeb.Endpoint.broadcast("canvas:updates", "new_tile", payload)
  end
end
