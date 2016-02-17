module DotsAndBoxes.WebSocketsPush (modelToWebSocketsPayload) where

import Json.Encode as Json exposing (object, string, int)
import DotsAndBoxes.Model exposing (Model)

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
    _ ->
      object
        [ ("game_id", int model.game_id) ]

