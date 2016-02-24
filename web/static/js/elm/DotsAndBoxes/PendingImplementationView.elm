module DotsAndBoxes.PendingImplementationView (pendingImplementationView) where

import Html exposing (..)
import Html.Attributes exposing (class)
import DotsAndBoxes.Model exposing (Model)
import DotsAndBoxes.PlayersView exposing (playersList)

pendingImplementationView : Model -> Html
pendingImplementationView model =
  section
    [class "modal"]
    [ text ("Not yet implemented: " ++ toString model.game_id)
    , br [] []
    , text ("Player name: " ++ Maybe.withDefault "Not set" model.player_name)
    , br [] []
    , text ("Player guid: " ++ model.player_guid)
    , br [] []
    , playersList model.lobby.game.players
    ]
