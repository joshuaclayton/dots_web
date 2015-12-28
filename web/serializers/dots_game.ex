defimpl Poison.Encoder, for: Dots.Game do
  def encode(game, options) do
    game
    |> Map.from_struct
    |> Map.merge(%{current_player: %{name: Dots.Game.current_player(game)}})
    |> Poison.Encoder.encode(options)
  end
end
