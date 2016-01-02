defmodule DotsWeb.Game do
  use GenServer

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

  defp create_game(game_id) do
    GenServer.call(__MODULE__, {:update, game_id, Dots.Lobby.new})
  end

  defp add_player(lobby, player) do
    Dots.Lobby.add_player(lobby, %{id: player["id"], name: player["name"]})
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
