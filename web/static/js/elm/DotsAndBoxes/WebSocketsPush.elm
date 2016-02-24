module DotsAndBoxes.WebSocketsPush (signal) where

import Json.Encode as Json exposing (encode, object, string, int)
import DotsAndBoxes.Model exposing (nullModel, Model, SquareSide)

signal : Signal Model -> Signal String
signal model =
  Signal.map (\model' -> encode 0 (modelToWebSocketsPayload model')) (outboundModel model)

isUpdateableAction : Model -> Bool
isUpdateableAction model =
  case model.last_action of
    DotsAndBoxes.Model.SignUp -> True
    DotsAndBoxes.Model.StartGame -> True
    DotsAndBoxes.Model.ClaimSide square side -> True
    DotsAndBoxes.Model.UpdatePlayerGuid guid -> True
    DotsAndBoxes.Model.PlayAgain -> True
    _ -> False

outboundModel : Signal Model -> Signal Model
outboundModel model =
  Signal.filter isUpdateableAction nullModel model

modelToWebSocketsPayload : Model -> Json.Value
modelToWebSocketsPayload model =
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

    DotsAndBoxes.Model.ClaimSide square side ->
      object [ ("game_id", int model.game_id)
      , ("x", int square.coordinates.x)
      , ("y", int square.coordinates.y)
      , ("position", string (side |> sideToString))
      , ("action", string "game:claim")
      ]

    DotsAndBoxes.Model.UpdatePlayerGuid guid ->
      object [ ("game_id", int model.game_id)
      , ("player", string guid)
      , ("action", string "player:rejoin")
      ]

    DotsAndBoxes.Model.PlayAgain ->
      object [ ("game_id", int model.game_id)
      , ("action", string "game:playagain")
      ]
    _ ->
      object
        [ ("game_id", int model.game_id) ]

sideToString : SquareSide -> String
sideToString side =
  case side of
    DotsAndBoxes.Model.Top -> "Top"
    DotsAndBoxes.Model.Right -> "Right"
    DotsAndBoxes.Model.Bottom -> "Bottom"
    DotsAndBoxes.Model.Left -> "Left"
    _ -> ""
