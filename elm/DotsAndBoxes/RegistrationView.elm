module DotsAndBoxes.RegistrationView where

import Html exposing (..)
import Html.Events exposing (on, targetValue, onClick)
import Html.Attributes exposing (autocomplete, disabled, class, for, type', value, id)
import String exposing (trim)
import Signal exposing (Signal, Address)
import DotsAndBoxes.CustomEvent exposing (onSubmit)
import DotsAndBoxes.Model exposing (Model)
import DotsAndBoxes.Action exposing (Action)

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

sizeSelector : Address Action -> Model -> Int -> Html
sizeSelector address model size =
  let chosenClass = if model.board_size == size then "chosen" else ""
  in
  a
    [ onClick address(DotsAndBoxes.Action.ChooseSize size)
    , class chosenClass
    ]
    [text(formattedBoardSize size)]

formattedBoardSize : Int -> String
formattedBoardSize size =
  size
  |> toString
  |> List.repeat 2
  |> List.intersperse "x"
  |> List.foldr (++) ""

setPlayerName : String -> Action
setPlayerName fieldValue =
  DotsAndBoxes.Action.SetPlayerName(trim fieldValue)

registrationSubmitDisabled : Model -> Attribute
registrationSubmitDisabled model =
  case (model.player_name, model.board_size) of
    (Nothing, _) -> disabled True
    (_, 0)       -> disabled True
    (_, _)       -> disabled False
