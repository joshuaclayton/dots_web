defimpl Poison.Encoder, for: Dots.Game do
  def encode(game, options) do
    game
    |> Map.from_struct
    |> Map.merge(%{current_player: Dots.Game.current_player(game)})
    |> put_in([:score, :scores], scores_for(game))
    |> Poison.Encoder.encode(options)
  end

  defp scores_for(%{score: %{} = score}) when map_size(score) == 0 do
    []
  end

  defp scores_for(%{score: %{scores: _scores}} = game) do
    game.score.scores
    |> Enum.map(fn {key, value} ->
      %{player: key, score: value}
    end)
  end
end

defimpl Poison.Encoder, for: Dots.Player do
  def encode(player, options) do
    player
    |> Map.from_struct
    |> Poison.Encoder.encode(options)
  end
end
