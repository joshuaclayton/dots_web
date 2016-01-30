module DotsAndBoxes.Model where

type GameStatus = Unknown | NotStarted | Started

type alias Lobby =
  { width: Int
  , height: Int
  , status: GameStatus
  }

type alias Game =
  { id : Int }

nullLobby : Lobby
nullLobby = { width = 0, height = 0, status = Unknown }
