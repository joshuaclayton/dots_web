module DotsAndBoxes.Update (update) where

import DotsAndBoxes.Model exposing (..)
import DotsAndBoxes.Decode exposing (..)
import DotsAndBoxes.ListExtras exposing (detect)

update : Action -> Model -> Model
update action model =
  let modelWithAction = { model | last_action = action }
      newPlayer = { nullPlayer | name = Maybe.withDefault "" model.player_name, id = model.player_guid }
  in
  case action of
    DotsAndBoxes.Model.NoOp -> modelWithAction
    DotsAndBoxes.Model.UpdateGameState payload ->
      let lobby = decodeLobby payload
          player = playerToAssign model.player model.player_guid lobby
      in { modelWithAction | lobby = lobby, player = player }
    DotsAndBoxes.Model.UpdateGameId game_id -> { modelWithAction | game_id = game_id }
    DotsAndBoxes.Model.UpdatePlayerGuid guid ->
      let player = playerToAssign model.player guid model.lobby
      in { modelWithAction | player_guid = guid, player = player }
    DotsAndBoxes.Model.SetPlayerName "" -> { modelWithAction | player_name = Nothing }
    DotsAndBoxes.Model.SetPlayerName name -> { modelWithAction | player_name = Just name }
    DotsAndBoxes.Model.SignUp -> { modelWithAction | player = Just newPlayer }
    DotsAndBoxes.Model.ChooseSize board_size -> { modelWithAction | board_size = board_size }
    DotsAndBoxes.Model.StartGame -> modelWithAction
    DotsAndBoxes.Model.PlayAgain -> modelWithAction
    DotsAndBoxes.Model.ClaimSide square side -> modelWithAction

playerToAssign : Maybe Player -> Guid -> Lobby -> Maybe Player
playerToAssign player guid lobby =
  case player of
    Nothing -> playerFromGuid guid lobby
    Just val -> Just val

playerFromGuid : Guid -> Lobby -> Maybe Player
playerFromGuid guid lobby =
  detect (\player -> player.id == guid) lobby.game.players
