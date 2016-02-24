module DotsAndBoxes where

import StartApp
import Effects exposing (Never, Effects)
import DotsAndBoxes.Model exposing (nullModel, nullPlayer, isCurrentPlayer, Model, Action, Guid)
import DotsAndBoxes.View exposing (mainView)
import DotsAndBoxes.Update exposing (update)
import DotsAndBoxes.WebSocketsPush exposing (modelToWebSocketsPayload)
import Html exposing (Html)
import Json.Encode as Json

isUpdateableAction : Model -> Bool
isUpdateableAction model =
  case model.last_action of
    DotsAndBoxes.Model.SignUp -> True
    DotsAndBoxes.Model.StartGame -> True
    DotsAndBoxes.Model.ClaimSide square side -> True
    DotsAndBoxes.Model.UpdatePlayerGuid guid -> True
    DotsAndBoxes.Model.PlayAgain -> True
    _ -> False

outboundModel : Signal Model
outboundModel =
  Signal.filter isUpdateableAction nullModel app.model

outboundActionsPayload : Signal Json.Value
outboundActionsPayload =
  Signal.map modelToWebSocketsPayload outboundModel

noEffects : a -> (a, Effects b)
noEffects thing = (thing, Effects.none)

init = noEffects nullModel

inputs : List (Signal Action)
inputs =
  [ DotsAndBoxes.Model.UpdateGameId `fromPort` setGameId
  , DotsAndBoxes.Model.UpdateGameState `fromPort` setState
  , DotsAndBoxes.Model.UpdatePlayerGuid `fromPort` setPlayerGuid
  , DotsAndBoxes.Model.UpdateClaimedSide `fromPort` setClaimedSide
  ]

fromPort : (a -> b) -> Signal a -> Signal b
fromPort action inboundPort =
  (Signal.map <| action) inboundPort

port setGameId : Signal Int
port setPlayerGuid : Signal Guid
port setState : Signal Json.Value
port setClaimedSide : Signal Json.Value

port broadcastUpdates : Signal String
port broadcastUpdates =
  (Signal.map <| Json.encode 0) outboundActionsPayload

port broadcastIsCurrentPlayer : Signal Bool
port broadcastIsCurrentPlayer =
  (Signal.map isCurrentPlayer app.model) |> Signal.dropRepeats

app = StartApp.start { init = init, view = mainView, update = update, inputs = inputs }

main = app.html
