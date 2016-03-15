module DotsAndBoxes.WebSocketsPush (signal) where

import Json.Encode as Json exposing (encode, object, string, int)
import DotsAndBoxes.Model exposing (nullModel, nullPlayer, Model, SquareSide)

signal : Signal Model -> Signal String
signal model =
  Signal.map (\model' -> encode 0 (modelToWebSocketsPayload model')) model

modelToWebSocketsPayload : Model -> Json.Value
modelToWebSocketsPayload model =
  let basePayload list = object <| ("game_id", int model.game_id) :: list
      playerName = (Maybe.withDefault nullPlayer model.player).name
  in case model.last_action of
    DotsAndBoxes.Model.HandlePlayerRegistration _ ->
      if model.registration.signup_complete then
        basePayload [
          ("width", int model.registration.board_size)
        , ("height", int model.registration.board_size)
        , ("player", object [("name", string playerName), ("id", string model.player_guid)])
        , ("action", string "game:begin")
        ]
      else
        basePayload []

    DotsAndBoxes.Model.StartGame ->
      basePayload [ ("action", string "game:start") ]

    DotsAndBoxes.Model.ClaimSide square side ->
      basePayload [
        ("x", int square.coordinates.x)
      , ("y", int square.coordinates.y)
      , ("position", string (side |> sideToString))
      , ("action", string "game:claim")
      ]

    DotsAndBoxes.Model.UpdatePlayerGuid guid ->
      basePayload [
        ("player", string guid)
      , ("action", string "player:rejoin")
      ]

    DotsAndBoxes.Model.PlayAgain ->
      basePayload [ ("action", string "game:playagain") ]

    _ ->
      basePayload []

sideToString : SquareSide -> String
sideToString side =
  case side of
    DotsAndBoxes.Model.Top -> "Top"
    DotsAndBoxes.Model.Right -> "Right"
    DotsAndBoxes.Model.Bottom -> "Bottom"
    DotsAndBoxes.Model.Left -> "Left"
    _ -> ""
