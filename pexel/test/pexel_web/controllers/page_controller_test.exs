defmodule PexelWeb.PageControllerTest do
  use PexelWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200)
  end
end
