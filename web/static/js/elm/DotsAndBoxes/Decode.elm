module DotsAndBoxes.Decode (decodeLobby) where

import Json.Encode as Json
import Json.Decode exposing (Decoder, maybe, null, oneOf, decodeValue, list, succeed, andThen, int, string, bool, (:=))
import Json.Decode.Extra exposing ((|:))
import DotsAndBoxes.Model exposing (nullLobby, nullPlayer, SquareSide, Lobby, Game, Claim, Board, Score, Square, Coordinate, Player, PlayerScore, GameStatus)

decodeLobby : Json.Value -> Lobby
decodeLobby payload =
  case decodeValue lobby payload of
    Ok val -> val
    Err message -> nullLobby

lobbyStatus : String -> GameStatus
lobbyStatus status =
  case status of
    "not_started" -> DotsAndBoxes.Model.NotStarted
    "started" -> DotsAndBoxes.Model.Started
    _ -> DotsAndBoxes.Model.Unknown

sidePosition : String -> SquareSide
sidePosition position =
  case position of
    "Top" -> DotsAndBoxes.Model.Top
    "Right" -> DotsAndBoxes.Model.Right
    "Bottom" -> DotsAndBoxes.Model.Bottom
    "Left" -> DotsAndBoxes.Model.Left
    _ -> DotsAndBoxes.Model.UnknownSide

decodePosition : String -> Decoder SquareSide
decodePosition position =
  succeed (sidePosition position)

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

claim : Decoder Claim
claim =
  succeed Claim
    |: (("position" := string) `andThen` decodePosition)
    |: ("player" := player)

coordinate : Decoder Coordinate
coordinate =
  succeed Coordinate
    |: ("x" := int)
    |: ("y" := int)

square : Decoder Square
square =
  succeed Square
    |: ("completed_by" := maybe player)
    |: ("coordinates" := coordinate)
    |: ("claims" := list claim)

board : Decoder Board
board =
  succeed Board
    |: ("squares" := list square)

game : Decoder Game
game =
  succeed Game
    |: ("current_player" := oneOf [player, null nullPlayer])
    |: ("players" := list player)
    |: ("completed" := bool)
    |: ("score" := score)
    |: ("board" := maybe board)

lobby : Decoder Lobby
lobby =
  succeed Lobby
  |: ("width" := int)
  |: ("height" := int)
  |: (("status" := string) `andThen` decodeStatus)
  |: ("game" := game)
