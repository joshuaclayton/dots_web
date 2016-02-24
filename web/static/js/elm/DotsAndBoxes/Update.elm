module DotsAndBoxes.Update (update) where

import Effects exposing (Never, Effects)
import DotsAndBoxes.Model exposing (..)
import DotsAndBoxes.Decode exposing (..)
import DotsAndBoxes.ListExtras exposing (detect)

noEffects : a -> (a, Effects b)
noEffects thing = (thing, Effects.none)

update : Action -> Model -> (Model, Effects Action)
update action model =
  let modelWithAction = { model | last_action = action }
      newPlayer = { nullPlayer | name = Maybe.withDefault "" model.player_name, id = model.player_guid }
  in
  case action of
    DotsAndBoxes.Model.NoOp -> noEffects modelWithAction
    DotsAndBoxes.Model.UpdateGameState payload ->
      let lobby = decodeLobby payload
          player = playerToAssign model.player model.player_guid lobby
      in noEffects { modelWithAction | lobby = lobby, player = player }
    DotsAndBoxes.Model.UpdateClaimedSide payload ->
      let claimedSide = decodeClaimedSide payload
      in noEffects { modelWithAction | last_claimed_side = claimedSide }
    DotsAndBoxes.Model.UpdateGameId game_id -> noEffects { modelWithAction | game_id = game_id }
    DotsAndBoxes.Model.UpdatePlayerGuid guid ->
      let player = playerToAssign model.player guid model.lobby
      in noEffects { modelWithAction | player_guid = guid, player = player }
    DotsAndBoxes.Model.SetPlayerName "" -> noEffects { modelWithAction | player_name = Nothing }
    DotsAndBoxes.Model.SetPlayerName name -> noEffects { modelWithAction | player_name = Just name }
    DotsAndBoxes.Model.SignUp -> noEffects { modelWithAction | player = Just newPlayer }
    DotsAndBoxes.Model.ChooseSize board_size -> noEffects { modelWithAction | board_size = board_size }
    DotsAndBoxes.Model.StartGame -> noEffects modelWithAction
    DotsAndBoxes.Model.PlayAgain -> noEffects modelWithAction
    DotsAndBoxes.Model.ClaimSide square side -> noEffects modelWithAction

playerToAssign : Maybe Player -> Guid -> Lobby -> Maybe Player
playerToAssign player guid lobby =
  case player of
    Nothing -> playerFromGuid guid lobby
    Just val -> Just val

playerFromGuid : Guid -> Lobby -> Maybe Player
playerFromGuid guid lobby =
  detect (\player -> player.id == guid) lobby.game.players
