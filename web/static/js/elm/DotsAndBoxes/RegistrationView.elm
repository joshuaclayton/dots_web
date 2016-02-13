module DotsAndBoxes.RegistrationView where

import Html exposing (..)
import Html.Events exposing (on, targetValue, onClick)
import Html.Attributes exposing (autocomplete, disabled, class, for, type', value, id)
import String exposing (trim)
import Signal exposing (Signal, Address)
import DotsAndBoxes.CustomEvent exposing (onSubmit)
import DotsAndBoxes.Model exposing (Model, Action)

registrationView : Address Action -> Model -> Html
registrationView address model =
  section
    [class "registration modal"]
    [
      h2 [class "title"] [text "Let's get started!"],
      form
        [onSubmit address DotsAndBoxes.Model.SignUp]
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
          boardSizeSelector address model,
          li [] [
            input
              [type' "submit", value "Game on!", registrationSubmitDisabled model]
              []
          ]
        ]
      ]
    ]

boardChosen : Model -> Bool
boardChosen model =
  case (model.lobby.width, model.lobby.height) of
    (0, 0) -> False
    (_, _) -> True

boardSizeSelector : Address Action -> Model -> Html
boardSizeSelector address model =
  if boardChosen model then
    li [] []
  else
    li [] [
      label
        [for "board_size"]
        [text "Next, what board size do you prefer?"]
    , section
      [class "size-selector"]
      (List.map (sizeSelector address model) [2, 5, 10])
    ]

sizeSelector : Address Action -> Model -> Int -> Html
sizeSelector address model size =
  let chosenClass = if model.board_size == size then "chosen" else ""
  in
  a
    [ onClick address(DotsAndBoxes.Model.ChooseSize size)
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
  DotsAndBoxes.Model.SetPlayerName(trim fieldValue)

registrationSubmitDisabled : Model -> Attribute
registrationSubmitDisabled model =
  case (model.player_name, model.board_size, model.lobby.width) of
    (Nothing, _, _) -> disabled True
    (_, 0, 0)       -> disabled True
    (_, _, _)       -> disabled False
