module DotsAndBoxes.Model where

type GameStatus = Unknown | NotStarted | Started

type alias Lobby =
  { width: Int
  , height: Int
  , status: GameStatus
  }

type alias Model =
  { lobby: Lobby
  , game_id: Int
  , player_name: Maybe String
  , board_size: Int
  }

nullLobby : Lobby
nullLobby = { width = 0, height = 0, status = Unknown }

nullModel : Model
nullModel = { game_id = 0, lobby = nullLobby, player_name = Nothing, board_size = 0 }
