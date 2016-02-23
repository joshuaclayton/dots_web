defmodule DotsWeb.Game do
  use GenServer

  def start_game do
    :random.seed :os.timestamp
    random_id = :random.uniform(1_000_000_000)
    {:ok, random_id, start(random_id)}
  end

  def start(game_id) do
    find(game_id) || create_game(game_id)
  end

  def find(game_id) do
    GenServer.call(__MODULE__, {:find, game_id})
  end

  def update(lobby, game_id) do
    GenServer.call(__MODULE__, {:update, game_id, lobby})
  end

  def configure(game_id, %{player: player, width: width, height: height}) when height > 0 do
    find(game_id)
    |> add_player(player)
    |> choose_dimensions(width, height)
    |> update(game_id)
  end

  def configure(game_id, %{player: player, width: width, height: height}) when height == 0 do
    find(game_id)
    |> add_player(player)
    |> update(game_id)
  end

  def play_again(old_game_id) do
    old_lobby = find(old_game_id)
    {:ok, new_game_id, new_lobby} = DotsWeb.Game.start_game

    new_lobby
    |> choose_dimensions(old_lobby.width, old_lobby.height)
    |> update(new_game_id)

    old_lobby.game.players
    |> Enum.each(fn player ->
      configure new_game_id, %{player: player, width: 0, height: 0}
    end)

    find(new_game_id)
    |> Dots.Lobby.start
    |> update(new_game_id)

    {:ok, new_game_id}
  end

  defp create_game(game_id) do
    GenServer.call(__MODULE__, {:update, game_id, Dots.Lobby.new})
  end

  defp add_player(lobby, %{id: id, name: name}) do
    Dots.Lobby.add_player(lobby, %{id: id, name: name})
  end

  defp choose_dimensions(lobby, width, height) do
    Dots.Lobby.choose_dimensions(lobby, width, height)
  end

  # GenServer

  def handle_call({:update, game_id, lobby}, _from, state) do
    new_state = Map.put state, game_id, lobby
    {:reply, lobby, new_state}
  end

  def handle_call({:find, game_id}, _from, state) do
    lobby = Map.get(state, game_id, nil)
    {:reply, lobby, state}
  end

  def start_link(opts \\ []) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, %{}, opts)
  end
end
