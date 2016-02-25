module DotsAndBoxes.Update (update) where

import Effects exposing (Effects)
import DotsAndBoxes.Model exposing (..)
import DotsAndBoxes.Decode exposing (..)
import DotsAndBoxes.ListExtras exposing (detect)
import DotsAndBoxes.Effect exposing (..)
import DotsAndBoxes.PlayerRegistration

update : Action -> Model -> (Model, Effects Action)
update action model =
  let modelWithAction = { model | last_action = action }
  in case action of
    DotsAndBoxes.Model.NoOp -> noEffects modelWithAction
    DotsAndBoxes.Model.UpdateGameState payload ->
      let lobby = decodeLobby payload
          player = playerToAssign model.player model.player_guid lobby
          newRegistration = DotsAndBoxes.PlayerRegistration.updateWithBoardSize model.registration lobby.width
      in noEffects { modelWithAction | lobby = lobby, player = player, registration = newRegistration }
    DotsAndBoxes.Model.UpdateClaimedSide payload ->
      let claimedSide = decodeClaimedSide payload
      in noEffects { modelWithAction | last_claimed_side = claimedSide }
    DotsAndBoxes.Model.UpdateGameId game_id -> noEffects { modelWithAction | game_id = game_id }
    DotsAndBoxes.Model.UpdatePlayerGuid guid ->
      let player = playerToAssign model.player guid model.lobby
      in noEffects { modelWithAction | player_guid = guid, player = player }
    DotsAndBoxes.Model.HandlePlayerRegistration act ->
      let (newRegistration, effects) = DotsAndBoxes.PlayerRegistration.update act model.registration
          resultModel = { modelWithAction | registration = newRegistration }
      in noEffects { resultModel | player = registrationPlayer newRegistration model.player_guid }
    DotsAndBoxes.Model.StartGame -> noEffects modelWithAction
    DotsAndBoxes.Model.PlayAgain -> noEffects modelWithAction
    DotsAndBoxes.Model.ClaimSide square side -> noEffects modelWithAction

playerToAssign : Maybe Player -> Guid -> Lobby -> Maybe Player
playerToAssign player guid lobby =
  let playerFromGuid guid players = detect (\player -> player.id == guid) players
  in case player of
    Nothing -> playerFromGuid guid lobby.game.players
    Just val -> Just val

registrationPlayer : DotsAndBoxes.PlayerRegistration.Model -> Guid -> Maybe Player
registrationPlayer registration guid =
  let buildPlayer = { nullPlayer | name = Maybe.withDefault "" registration.player_name, id = guid }
  in if registration.signup_complete then Just buildPlayer else Nothing
