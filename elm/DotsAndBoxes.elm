module DotsAndBoxes where

import DotsAndBoxes.Model exposing (nullLobby, Lobby, Game)
import DotsAndBoxes.View exposing (loadingView, pendingImplementationView, registrationView)
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Encode as Json
import Json.Decode exposing (decodeValue)

import DotsAndBoxes.Decode exposing (lobbyDecoder)

initialGame : Game
initialGame = { id = 1 }

update : Int -> Game -> Game
update gameId _ =
  { id = gameId }

updateLobby : Json.Value -> Lobby -> Lobby
updateLobby payload oldLobby =
  let newLobby = decodeValue lobbyDecoder payload
  in
     Result.withDefault oldLobby newLobby

view : Lobby -> Html
view lobby =
  case lobby.status of
    DotsAndBoxes.Model.Unknown -> loadingView
    DotsAndBoxes.Model.NotStarted -> registrationView
    _ -> pendingImplementationView

gameState : Signal Game
gameState = Signal.foldp update initialGame setGameId

lobbyState : Signal Lobby
lobbyState = Signal.foldp updateLobby nullLobby setState

main : Signal Html
main = Signal.map view lobbyState

port setGameId : Signal Int
port setState : Signal Json.Value
