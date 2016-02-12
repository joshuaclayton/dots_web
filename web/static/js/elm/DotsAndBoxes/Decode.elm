module DotsAndBoxes.Decode where

import Json.Encode as Json
import Json.Decode exposing (Decoder, null, oneOf, decodeValue, list, succeed, andThen, int, string, (:=))
import Json.Decode.Extra exposing ((|:))
import DotsAndBoxes.Model exposing (nullLobby, Lobby, Game, Player, GameStatus)

decodeLobby : Json.Value -> Lobby
decodeLobby payload =
  let decodedLobby = decodeValue lobbyDecoder payload
  in
     Result.withDefault nullLobby decodedLobby

lobbyStatus : String -> GameStatus
lobbyStatus status =
  case status of
    "not_started" -> DotsAndBoxes.Model.NotStarted
    "started" -> DotsAndBoxes.Model.Started
    _ -> DotsAndBoxes.Model.Unknown

decodeStatus : String -> Decoder GameStatus
decodeStatus status =
  succeed(lobbyStatus status)

playerDecoder : Decoder Player
playerDecoder =
  succeed Player
    |: ("name" := string)

gameDecoder : Decoder Game
gameDecoder =
  succeed Game
    |: ("current_player" := oneOf [ int, null 0 ])
    |: ("players" := list playerDecoder)

lobbyDecoder : Decoder Lobby
lobbyDecoder =
  succeed Lobby
  |: ("width" := int)
  |: ("height" := int)
  |: (("status" := string) `andThen` decodeStatus)
  |: ("game" := gameDecoder)
