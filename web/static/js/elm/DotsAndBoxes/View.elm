module DotsAndBoxes.View where

import Html exposing (..)
import Html.Attributes exposing (class)
import Signal exposing (Address)
import DotsAndBoxes.Model exposing (Action, Model)
import DotsAndBoxes.RegistrationView exposing (registrationView)

mainView : Address Action -> Model -> Html
mainView address model =
  case model.lobby.status of
    DotsAndBoxes.Model.Unknown -> loadingView
    DotsAndBoxes.Model.NotStarted -> notStartedView address model
    _ -> pendingImplementationView model

loadingView : Html
loadingView =
  section
    [class "modal"]
    [text "Loading the game..."]

notStartedView : Address Action -> Model -> Html
notStartedView address model =
  registrationView address model

pendingImplementationView : Model -> Html
pendingImplementationView model =
  section
    [class "modal"]
    [ text ("Not yet implemented: " ++ toString model.game_id)
    , text ("Player name: " ++ Maybe.withDefault "Not set" model.player_name)
    ]
