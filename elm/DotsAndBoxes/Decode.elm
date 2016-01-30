module DotsAndBoxes.Decode where

import Json.Decode exposing (Decoder, succeed, andThen, map, int, string, (:=))
import Json.Decode.Extra exposing (apply)
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
lobbyDecoder = Lobby
  `map` ("width" := int)
  `apply` ("height" := int)
  `apply` (("status" := string) `andThen` decodeStatus)
