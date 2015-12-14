defmodule DotsWeb.GameController do
  use DotsWeb.Web, :controller

  def show(conn, %{"id" => id}) do
    game_id = id |> String.to_integer
    DotsWeb.Game.start(game_id)

    spawn_link DotsWeb.GameController, :broadcast, [game_id]
    render conn, "show.html", game_id: game_id
  end

  def broadcast(game_id) do
    :timer.sleep 1000

    DotsWeb.Endpoint.broadcast!(
      "game",
      "game:update:#{game_id}",
      %{lobby: DotsWeb.Game.find(game_id)}
    )
  end
end
