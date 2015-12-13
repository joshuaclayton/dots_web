defmodule DotsWeb.PageController do
  use DotsWeb.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
