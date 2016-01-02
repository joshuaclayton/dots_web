defmodule DotsGame.DotsGameSerializerTest do
  use DotsWeb.ConnCase

  test "it works" do
    game_id = 12345

    DotsWeb.Game.start(game_id)
    DotsWeb.Game.find(game_id)
    |> Dots.Lobby.start
    |> DotsWeb.Game.update(game_id)

    DotsWeb.Game.configure(game_id, %{player: %{id: 1234, name: "Joe"}, width: 1, height: 1})

    claim_side game_id, "Top"
    claim_side game_id, "Right"
    claim_side game_id, "Bottom"
    claim_side game_id, "Left"

    assert Poison.encode!(DotsWeb.Game.find(game_id))
  end

  defp claim_side(game_id, side) do
    lobby = DotsWeb.Game.find(game_id)

    %{lobby | game: lobby.game |> Dots.Game.claim(0, 0, side)}
    |> DotsWeb.Game.update(game_id)
  end
end
