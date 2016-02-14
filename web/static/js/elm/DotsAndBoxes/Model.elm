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
  | StartGame

type alias Player =
  { name: String
  , active: Bool
  }

type alias Game =
  { current_player: Player
  , players: List Player
  }

type alias Lobby =
  { width: Int
  , height: Int
  , status: GameStatus
  , game: Game
  }

type alias Model =
  { lobby: Lobby
  , game_id: Int
  , player_name: Maybe String
  , board_size: Int
  , last_action: Action
  , player: Maybe Player
  }

nullPlayer : Player
nullPlayer = { name = "", active = True }

nullGame : Game
nullGame = { players = [], current_player = nullPlayer }

nullLobby : Lobby
nullLobby = { width = 0, height = 0, status = Unknown, game = nullGame }

nullModel : Model
nullModel = { game_id = 0, lobby = nullLobby, player_name = Nothing, board_size = 0, last_action = NoOp, player = Nothing }
