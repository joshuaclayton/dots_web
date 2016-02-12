module DotsAndBoxes.Decode where

import Json.Encode as Json
import Json.Decode exposing (Decoder, decodeValue, object3, succeed, andThen, int, string, (:=))
import Json.Decode.Extra exposing ((|:))
import DotsAndBoxes.Model exposing (nullLobby, Lobby, GameStatus)

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

lobbyDecoder : Decoder Lobby
lobbyDecoder =
  object3 Lobby
    ("width" := int)
    ("height" := int)
    (("status" := string) `andThen` decodeStatus)
