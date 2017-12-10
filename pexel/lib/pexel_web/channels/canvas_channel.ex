defmodule PexelWeb.CanvasChannel do
  use PexelWeb, :channel

  def join("canvas:updates", _payload, socket) do
    {:ok, socket}
  end
end
