module DotsAndBoxes.PendingImplementationView (pendingImplementationView) where

import Html exposing (..)
import Html.Attributes exposing (class)
import DotsAndBoxes.Model exposing (Model, nullPlayer)
import DotsAndBoxes.PlayersView exposing (playersList)

pendingImplementationView : Model -> Html
pendingImplementationView model =
  section
    [class "modal"]
    [ text ("Not yet implemented: " ++ toString model.game_id)
    , br [] []
    , text ("Player name: " ++ (Maybe.withDefault nullPlayer model.player).name)
    , br [] []
    , text ("Player guid: " ++ model.player_guid)
    , br [] []
    , playersList model.lobby.game.players
    ]
