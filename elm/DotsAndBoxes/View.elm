module DotsAndBoxes.View where

import Html exposing (..)
import Html.Attributes exposing (autocomplete, disabled, class, for, type', value, id)
import Html.Events exposing (on, targetValue, onClick)
import Json.Decode exposing (string, succeed)
import Signal exposing (Signal, Address)
import DotsAndBoxes.Model exposing (Model)
import DotsAndBoxes.Action exposing (Action)
import DotsAndBoxes.CustomEvent exposing (onSubmit)
import String exposing (trim)

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
    , text ("Player name: " ++ Maybe.withDefault "Not set" model.player_name)
    ]

sizeSelector : Address Action -> Model -> Int -> Html
sizeSelector address model size =
  let sizeString = size |> toString
      displaySize = sizeString ++ "x" ++ sizeString
      chosenClass = if model.board_size == size then "chosen" else ""
  in
  a
    [ onClick address(DotsAndBoxes.Action.ChooseSize size)
    , class chosenClass
    ]
    [text displaySize]

registrationSubmitDisabled : Model -> Attribute
registrationSubmitDisabled model =
  case (model.player_name, model.board_size) of
    (Nothing, _) -> disabled True
    (_, 0)       -> disabled True
    (_, _)       -> disabled False

setPlayerName : String -> Action
setPlayerName fieldValue =
  DotsAndBoxes.Action.SetPlayerName(trim fieldValue)

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
              , on "input" targetValue (Signal.message address << setPlayerName)
              , autocomplete False
              ]
              []
          ],
          li [] [
            label
              [for "board_size"]
              [text "Next, what board size do you prefer?"]
          , section
            [class "size-selector"]
            (List.map (sizeSelector address model) [2, 5, 10])
          ],
          li [] [
            input
              [type' "submit", value "Game on!", registrationSubmitDisabled model]
              []
          ]
        ]
      ]
    ]
