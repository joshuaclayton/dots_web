module DotsAndBoxes.Update where

import DotsAndBoxes.Model exposing (Action, Model)
import DotsAndBoxes.Decode exposing (decodeLobby)

update : Action -> Model -> Model
update action model =
  let modelWithAction = { model | last_action = action }
      newPlayer = { name = Maybe.withDefault "" model.player_name }
  in
  case action of
    DotsAndBoxes.Model.NoOp -> modelWithAction
    DotsAndBoxes.Model.UpdateGameState payload -> { modelWithAction | lobby = decodeLobby payload }
    DotsAndBoxes.Model.UpdateGameId game_id -> { modelWithAction | game_id = game_id }
    DotsAndBoxes.Model.SetPlayerName "" -> { modelWithAction | player_name = Nothing }
    DotsAndBoxes.Model.SetPlayerName name -> { modelWithAction | player_name = Just name }
    DotsAndBoxes.Model.SignUp -> { modelWithAction | player = Just newPlayer }
    DotsAndBoxes.Model.ChooseSize board_size -> { modelWithAction | board_size = board_size }
