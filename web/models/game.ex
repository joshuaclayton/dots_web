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

  defp create_game(game_id) do
    GenServer.call(__MODULE__, {:update, game_id, Dots.Lobby.new})
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
