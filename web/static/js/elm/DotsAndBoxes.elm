module DotsAndBoxes where

import DotsAndBoxes.Model exposing (nullModel, nullPlayer, isCurrentPlayer, Model, Action, Guid)
import DotsAndBoxes.View exposing (mainView)
import DotsAndBoxes.Update exposing (update)
import Html exposing (Html)
import Json.Encode as Json exposing (object, string, int)

model : Signal Model
model = Signal.foldp update nullModel inputs

inputs : Signal Action
inputs =
  Signal.mergeMany ([actions.signal] ++ inboundPorts)

updateableActions : List Action
updateableActions =
  [ DotsAndBoxes.Model.SignUp
  , DotsAndBoxes.Model.StartGame
  ]

isUpdateableAction : Model -> Bool
isUpdateableAction model =
  List.member model.last_action updateableActions

outboundModel : Signal Model
outboundModel =
  Signal.filter isUpdateableAction nullModel model

toPayloadValue : Model -> Json.Value
toPayloadValue model =
  case model.last_action of
    DotsAndBoxes.Model.SignUp ->
      object [ ("game_id", int model.game_id)
      , ("width", int model.board_size)
      , ("height", int model.board_size)
      , ("player", object [("name", string(Maybe.withDefault "Unknown" model.player_name)), ("id", string model.player_guid)])
      , ("action", string "game:begin")
      ]
    DotsAndBoxes.Model.StartGame ->
      object [ ("game_id", int model.game_id)
      , ("action", string "game:start")
      ]
    _ ->
      object
        [ ("game_id", int model.game_id) ]

outboundActionsPayload : Signal Json.Value
outboundActionsPayload =
  Signal.map toPayloadValue outboundModel

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
