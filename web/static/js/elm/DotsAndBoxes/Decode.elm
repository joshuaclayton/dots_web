module DotsAndBoxes.Decode (decodeLobby) where

import Json.Encode as Json
import Json.Decode exposing (Decoder, maybe, null, oneOf, decodeValue, list, succeed, andThen, int, string, bool, (:=))
import Json.Decode.Extra exposing ((|:))
import DotsAndBoxes.Model exposing (nullLobby, nullPlayer, Lobby, Game, Score, Player, PlayerScore, GameStatus)

decodeLobby : Json.Value -> Lobby
decodeLobby payload =
  let decodedLobby = decodeValue lobby payload
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
  succeed (lobbyStatus status)

decodeWinners : Maybe (List Player) -> Decoder (List Player)
decodeWinners players =
  succeed (Maybe.withDefault [] players)

player : Decoder Player
player =
  succeed Player
    |: ("name" := string)
    |: ("active" := bool)
    |: ("id" := string)

playerScore : Decoder PlayerScore
playerScore =
  succeed PlayerScore
    |: ("player" := player)
    |: ("score" := int)

score : Decoder Score
score =
  succeed Score
    |: ((maybe ("winners" := list player)) `andThen` decodeWinners)
    |: ("scores" := list playerScore)

game : Decoder Game
game =
  succeed Game
    |: ("current_player" := oneOf [player, null nullPlayer])
    |: ("players" := list player)
    |: ("completed" := bool)
    |: ("score" := score)

lobby : Decoder Lobby
lobby =
  succeed Lobby
  |: ("width" := int)
  |: ("height" := int)
  |: (("status" := string) `andThen` decodeStatus)
  |: ("game" := game)
