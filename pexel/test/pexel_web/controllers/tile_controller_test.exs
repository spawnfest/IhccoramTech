defmodule PexelWeb.TileControllerTest do
  use PexelWeb.ConnCase

  alias Pexel.Canvas
  alias Pexel.Canvas.Tile

  @create_attrs %{color: 10, x: 42, y: 42}
  @update_attrs %{color: 11, x: 42, y: 42}
  @invalid_attrs %{color: 20, x: 42, y: 42}

  def fixture(:tile) do
    {:ok, tile} = Canvas.create_tile(@create_attrs)
    tile
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tiles", %{conn: conn} do
      conn = get conn, tile_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create tile" do
    test "renders tile when data is valid", %{conn: conn} do
      conn = post conn, tile_path(conn, :create), tile: @create_attrs
      assert %{"x" => x, "y" => y} = json_response(conn, 201)["data"]

      conn = get conn, tile_path(conn, :show, x, y)
      assert json_response(conn, 200)["data"] == %{
        "color" => 10,
        "x" => 42,
        "y" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, tile_path(conn, :create), tile: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update tile" do
    setup [:create_tile]

    test "renders tile when data is valid", %{conn: conn, tile: %Tile{x: x, y: y}} do
      conn = put conn, tile_path(conn, :update, x, y), tile: @update_attrs
      assert %{"x" => ^x, "y" => ^y} = json_response(conn, 200)["data"]

      conn = get conn, tile_path(conn, :show, x, y)
      assert json_response(conn, 200)["data"] == %{
        "color" => 11,
        "x" => 42,
        "y" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn, tile: %Tile{x: x, y: y}} do
      conn = put conn, tile_path(conn, :update, x, y), tile: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_tile(_) do
    tile = fixture(:tile)
    {:ok, tile: tile}
  end
end
