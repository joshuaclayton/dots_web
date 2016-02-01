module DotsAndBoxes.Decode where

import Json.Decode exposing (Decoder, succeed, andThen, int, string, (:=))
import Json.Decode.Extra exposing ((|:))
import DotsAndBoxes.Model exposing (Lobby, GameStatus)

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
  succeed Lobby
    |: ("width" := int)
    |: ("height" := int)
    |: (("status" := string) `andThen` decodeStatus)
