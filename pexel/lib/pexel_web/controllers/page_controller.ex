defmodule PexelWeb.PageController do
  use PexelWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
