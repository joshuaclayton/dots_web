module DotsAndBoxes.Action where

import Json.Encode as Json
import DotsAndBoxes.Model exposing (Model)
import DotsAndBoxes.Decode exposing (decodeLobby)

type Action
  = NoOp
  | UpdateGameId Int
  | UpdateGameState Json.Value
  | SetPlayerName String
  | SignUp

update : Action -> Model -> Model
update action model =
  case action of
    NoOp -> model
    UpdateGameState payload -> { model | lobby = decodeLobby payload }
    UpdateGameId game_id -> { model | game_id = game_id }
    SetPlayerName name -> { model | player_name = name }
    SignUp -> model
