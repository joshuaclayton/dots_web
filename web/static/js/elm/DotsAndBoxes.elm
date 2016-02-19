module DotsAndBoxes where

import DotsAndBoxes.Model exposing (nullModel, nullPlayer, isCurrentPlayer, Model, Action, Guid)
import DotsAndBoxes.View exposing (mainView)
import DotsAndBoxes.Update exposing (update)
import DotsAndBoxes.WebSocketsPush exposing (modelToWebSocketsPayload)
import Html exposing (Html)
import Json.Encode as Json

model : Signal Model
model = Signal.foldp update nullModel inputs

inputs : Signal Action
inputs =
  Signal.mergeMany ([actions.signal] ++ inboundPorts)

isUpdateableAction : Model -> Bool
isUpdateableAction model =
  case model.last_action of
    DotsAndBoxes.Model.SignUp -> True
    DotsAndBoxes.Model.StartGame -> True
    DotsAndBoxes.Model.ClaimSide square side -> True
    DotsAndBoxes.Model.UpdatePlayerGuid guid -> True
    _ -> False

outboundModel : Signal Model
outboundModel =
  Signal.filter isUpdateableAction nullModel model

outboundActionsPayload : Signal Json.Value
outboundActionsPayload =
  Signal.map modelToWebSocketsPayload outboundModel

actions : Signal.Mailbox Action
actions =
  Signal.mailbox DotsAndBoxes.Model.NoOp

inboundPorts : List (Signal Action)
inboundPorts =
  [ DotsAndBoxes.Model.UpdateGameId `fromPort` setGameId
  , DotsAndBoxes.Model.UpdateGameState `fromPort` setState
  , DotsAndBoxes.Model.UpdatePlayerGuid `fromPort` setPlayerGuid
  ]

fromPort : (a -> b) -> Signal a -> Signal b
fromPort action inboundPort =
  (Signal.map <| action) inboundPort

main : Signal Html
main = Signal.map (mainView actions.address) model

port setGameId : Signal Int
port setPlayerGuid : Signal Guid
port setState : Signal Json.Value

port broadcastUpdates : Signal String
port broadcastUpdates =
  (Signal.map <| Json.encode 0) outboundActionsPayload

port broadcastIsCurrentPlayer : Signal Bool
port broadcastIsCurrentPlayer =
  (Signal.map isCurrentPlayer model) |> Signal.dropRepeats
