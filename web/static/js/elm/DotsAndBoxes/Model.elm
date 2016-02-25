module DotsAndBoxes.Model where

import Json.Encode as Json
import DotsAndBoxes.PlayerRegistration

type GameStatus = Unknown | NotStarted | Started

type Action
  = NoOp
  | UpdateGameId Int
  | UpdateGameState Json.Value
  | UpdateClaimedSide Json.Value
  | UpdatePlayerGuid Guid
  | HandlePlayerRegistration DotsAndBoxes.PlayerRegistration.Action
  | StartGame
  | ClaimSide Square SquareSide
  | PlayAgain

type SquareSide = Top | Right | Bottom | Left | UnknownSide

type alias Guid = String

type alias Side =
  { x: Int
  , y: Int
  , position: SquareSide
  }

type alias Player =
  { name: String
  , active: Bool
  , id: Guid
  }

type alias PlayerScore =
  { player: Player
  , score: Int }

type alias Score =
  { winners: List Player
  , scores: List PlayerScore }

type alias Claim =
  { position: SquareSide
  , player: Player
  }

type alias Coordinate =
  { x: Int
  , y: Int
  }

type alias Square =
  { completed_by: Maybe Player
  , coordinates: Coordinate
  , claims: List Claim
  }

type alias Board =
  { squares: List Square
  }

type alias Game =
  { current_player: Player
  , players: List Player
  , completed: Bool
  , score: Score
  , board: Maybe Board
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
  , last_action: Action
  , player: Maybe Player
  , player_guid: Guid
  , last_claimed_side: Side
  , registration: DotsAndBoxes.PlayerRegistration.Model
  }

isCurrentPlayer : Model -> Bool
isCurrentPlayer model =
  let thisPlayer = Maybe.withDefault nullPlayer model.player
      currentPlayer = model.lobby.game.current_player
  in
    thisPlayer.id == currentPlayer.id && model.lobby.status == Started

nullSide : Side
nullSide = { x = 0, y = 0, position = UnknownSide }

nullPlayer : Player
nullPlayer = { name = "", active = True, id = "" }

nullScore : Score
nullScore = { winners = [], scores = [] }

nullBoard : Board
nullBoard = { squares = [] }

nullGame : Game
nullGame = { players = [], current_player = nullPlayer, completed = False, score = nullScore, board = Nothing }

nullLobby : Lobby
nullLobby = { width = 0, height = 0, status = Unknown, game = nullGame }

nullModel : Model
nullModel = { game_id = 0, lobby = nullLobby, last_action = NoOp, player = Nothing, player_guid = "", last_claimed_side = nullSide, registration = DotsAndBoxes.PlayerRegistration.initialModel }
