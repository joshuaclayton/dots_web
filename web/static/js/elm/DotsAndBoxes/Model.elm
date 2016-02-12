module DotsAndBoxes.Model where

import Json.Encode as Json

type GameStatus = Unknown | NotStarted | Started

type Action
  = NoOp
  | UpdateGameId Int
  | UpdateGameState Json.Value
  | SetPlayerName String
  | ChooseSize Int
  | SignUp

type alias Player =
  { name: String }

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
  , last_action: Action
  , player: Maybe Player
  }

nullLobby : Lobby
nullLobby = { width = 0, height = 0, status = Unknown }

nullModel : Model
nullModel = { game_id = 0, lobby = nullLobby, player_name = Nothing, board_size = 0, last_action = NoOp, player = Nothing }
