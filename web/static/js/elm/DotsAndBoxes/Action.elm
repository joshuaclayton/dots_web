module DotsAndBoxes.Action where

import Json.Encode as Json
import DotsAndBoxes.Model exposing (Model)
import DotsAndBoxes.Decode exposing (decodeLobby)

type Action
  = NoOp
  | UpdateGameId Int
  | UpdateGameState Json.Value
  | SetPlayerName String
  | ChooseSize Int
  | SignUp

update : Action -> Model -> Model
update action model =
  case action of
    NoOp -> model
    UpdateGameState payload -> { model | lobby = decodeLobby payload }
    UpdateGameId game_id -> { model | game_id = game_id }
    SetPlayerName "" -> { model | player_name = Nothing }
    SetPlayerName name -> { model | player_name = Just name }
    SignUp -> model
    ChooseSize board_size -> { model | board_size = board_size }
