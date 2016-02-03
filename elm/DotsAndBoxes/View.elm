module DotsAndBoxes.View where

import Html exposing (..)
import Html.Attributes exposing (class, for, type', value, id)
import Html.Events exposing (on, targetValue)
import Json.Decode exposing (string)
import Signal exposing (Signal, Address)
import DotsAndBoxes.Model exposing (Model)
import DotsAndBoxes.Action exposing (Action)
import DotsAndBoxes.CustomEvent exposing (onSubmit)

mainView : Address Action -> Model -> Html
mainView address model =
  case model.lobby.status of
    DotsAndBoxes.Model.Unknown -> loadingView
    DotsAndBoxes.Model.NotStarted -> registrationView address model
    _ -> pendingImplementationView model

loadingView : Html
loadingView =
  section
    [class "modal"]
    [text "Loading game..."]

pendingImplementationView : Model -> Html
pendingImplementationView model =
  section
    [class "modal"]
    [ text ("Not yet implemented: " ++ toString model.game_id)
    , text ("Player name: " ++ model.player_name)
    ]

registrationView : Address Action -> Model -> Html
registrationView address model =
  section
    [class "registration modal"]
    [
      h2 [class "title"] [text "Let's get started!"],
      form
        [onSubmit address DotsAndBoxes.Action.SignUp]
        [
        ul [] [
          li [] [
            label [for "player_name"] [text "First, what's your name?"],
            input
              [ type' "text"
              , id "player_name"
              , on "input" targetValue (Signal.message address << DotsAndBoxes.Action.SetPlayerName)
              ]
              []
          ],
          li [] [
            label
              [for "board_size"]
              [text "Next, what board size do you prefer?"]
          ],
          li [] [
            input
              [type' "submit", value "Game on!"]
              []
          ]
        ]
      ]
    ]
