defmodule DotsWeb.PageControllerTest do
  use DotsWeb.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
