module DotsAndBoxes where

import DotsAndBoxes.Model exposing (nullLobby, Lobby)
import DotsAndBoxes.View exposing (mainView)
import Html exposing (..)
import Json.Encode as Json
import Json.Decode exposing (decodeValue)
import DotsAndBoxes.Decode exposing (lobbyDecoder)

updateLobby : Json.Value -> Lobby -> Lobby
updateLobby payload oldLobby =
  let newLobby = decodeValue lobbyDecoder payload
  in
     Result.withDefault oldLobby newLobby

lobbyState : Signal Lobby
lobbyState = Signal.foldp updateLobby nullLobby setState

main : Signal Html
main = Signal.map mainView lobbyState

port setGameId : Signal Int
port setState : Signal Json.Value
