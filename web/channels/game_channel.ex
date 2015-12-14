defmodule DotsWeb.Channels.GameChannel do
  use Phoenix.Channel

  defp input_to_integer(binary) do
    binary |> to_string |> String.to_integer
  end

  def handle_in("game:begin", %{"game_id" => id, "player" => player, "width" => width, "height" => height}, socket) do
    game_id = id |> input_to_integer

    DotsWeb.Game.find(game_id)
    |> Dots.Lobby.add_player(player)
    |> Dots.Lobby.choose_dimensions(width |> input_to_integer, height |> input_to_integer)
    |> DotsWeb.Game.update(game_id)

    broadcast_game_update(socket, game_id)
    {:noreply, socket}
  end

  def handle_in("game:claim", %{"game_id" => id, "position" => position, "x" => x, "y" => y}, socket) do
    game_id = id |> input_to_integer
    x_pos = x |> input_to_integer
    y_pos = y |> input_to_integer

    lobby = DotsWeb.Game.find(game_id)

    %{lobby | game: lobby.game |> Dots.Game.claim(x_pos, y_pos, position)}
    |> DotsWeb.Game.update(game_id)

    broadcast_game_update(socket, game_id)
    {:noreply, socket}
  end

  def handle_in("game:start", %{"game_id" => id}, socket) do
    game_id = id |> to_string |> String.to_integer

    DotsWeb.Game.find(game_id)
    |> Dots.Lobby.start
    |> DotsWeb.Game.update(game_id)

    broadcast_game_update(socket, game_id)
    {:noreply, socket}
  end

  def handle_in("player:leave", %{"game_id" => id, "player" => player}, socket) do
    game_id = id |> to_string |> String.to_integer

    DotsWeb.Game.find(game_id)
    |> Dots.Lobby.remove_player(player)
    |> DotsWeb.Game.update(game_id)

    broadcast_game_update(socket, game_id)
    {:noreply, socket}
  end

  def join(_topic, _params, socket) do
    {:ok, socket}
  end

  defp broadcast_game_update(socket, game_id) do
    broadcast!(socket, "game:update:#{game_id}", %{lobby: DotsWeb.Game.find(game_id)})
  end
end
