defmodule PexelWeb.TileControllerTest do
  use PexelWeb.ConnCase

  alias Pexel.Canvas
  alias Pexel.Canvas.Tile

  @create_attrs %{color: "some color", x: 42, y: 42}
  @update_attrs %{color: "some updated color", x: 43, y: 43}
  @invalid_attrs %{color: nil, x: nil, y: nil}

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
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, tile_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "color" => "some color",
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

    test "renders tile when data is valid", %{conn: conn, tile: %Tile{id: id} = tile} do
      conn = put conn, tile_path(conn, :update, tile), tile: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, tile_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "color" => "some updated color",
        "x" => 43,
        "y" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, tile: tile} do
      conn = put conn, tile_path(conn, :update, tile), tile: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete tile" do
    setup [:create_tile]

    test "deletes chosen tile", %{conn: conn, tile: tile} do
      conn = delete conn, tile_path(conn, :delete, tile)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, tile_path(conn, :show, tile)
      end
    end
  end

  defp create_tile(_) do
    tile = fixture(:tile)
    {:ok, tile: tile}
  end
end
