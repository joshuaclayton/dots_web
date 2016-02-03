module DotsAndBoxes where

import DotsAndBoxes.Model exposing (nullModel, Model)
import DotsAndBoxes.View exposing (mainView)
import DotsAndBoxes.Action exposing (Action, update)
import Html exposing (Html)
import Json.Encode as Json

model : Signal Model
model = Signal.foldp update nullModel inputs

inputs : Signal Action
inputs =
  Signal.mergeMany
  [ actions.signal
  , updateGameId
  , updateGameState
  ]

actions : Signal.Mailbox Action
actions =
  Signal.mailbox DotsAndBoxes.Action.NoOp

updateGameId : Signal Action
updateGameId =
  Signal.map (\game_id -> DotsAndBoxes.Action.UpdateGameId game_id) setGameId

updateGameState : Signal Action
updateGameState =
  Signal.map (\payload -> DotsAndBoxes.Action.UpdateGameState payload) setState

main : Signal Html
main = Signal.map (mainView actions.address) model

port setGameId : Signal Int
port setState : Signal Json.Value
