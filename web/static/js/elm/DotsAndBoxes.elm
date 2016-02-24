module DotsAndBoxes where

import StartApp
import DotsAndBoxes.Model exposing (..)
import DotsAndBoxes.View exposing (mainView)
import DotsAndBoxes.Update exposing (update)
import DotsAndBoxes.WebSocketsPush as WebSocketsPush
import Html exposing (Html)
import DotsAndBoxes.Port exposing (..)
import DotsAndBoxes.Effect exposing (..)
import Json.Encode as Json

inputs : List (Signal Action)
inputs =
  [ DotsAndBoxes.Model.UpdateGameId `fromPort` setGameId
  , DotsAndBoxes.Model.UpdateGameState `fromPort` setState
  , DotsAndBoxes.Model.UpdatePlayerGuid `fromPort` setPlayerGuid
  , DotsAndBoxes.Model.UpdateClaimedSide `fromPort` setClaimedSide
  ]

port setGameId : Signal Int
port setPlayerGuid : Signal Guid
port setState : Signal Json.Value
port setClaimedSide : Signal Json.Value

port broadcastUpdates : Signal String
port broadcastUpdates = WebSocketsPush.signal app.model

port broadcastIsCurrentPlayer : Signal Bool
port broadcastIsCurrentPlayer =
  (Signal.map isCurrentPlayer app.model) |> Signal.dropRepeats

app = StartApp.start { init = noEffects nullModel, view = mainView, update = update, inputs = inputs }

main = app.html
