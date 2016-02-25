module DotsAndBoxes.PlayerRegistration (Model, Action, update, updateWithBoardSize, view, initialModel) where

import Effects exposing (Effects)
import DotsAndBoxes.CustomEvent exposing (onSubmit)
import Html exposing (..)
import Html.Attributes exposing (autocomplete, disabled, class, for, type', value, id)
import Html.Events exposing (on, targetValue, onClick)
import String exposing (trim)
import DotsAndBoxes.Effect exposing (..)

type Action = NoOp
  | UpdateName String
  | ChooseSize Int
  | Submit

type alias Model = { board_size: Int, player_name: Maybe String, signup_complete: Bool, board_chosen_externally: Bool }

initialModel : Model
initialModel = { board_size = 0, player_name = Nothing, signup_complete = False, board_chosen_externally = False }

updateWithBoardSize : Model -> Int -> Model
updateWithBoardSize model boardSize =
  { model | board_size = boardSize, board_chosen_externally = boardSize > 0 }

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    UpdateName "" -> noEffects { model | player_name = Nothing }
    UpdateName name -> noEffects { model | player_name = Just name }
    ChooseSize board_size -> noEffects { model | board_size = board_size }
    Submit -> noEffects { model | signup_complete = True }
    _ -> noEffects model

view : Signal.Address Action -> Model -> Html
view address model =
  section
    [class "registration modal"]
    [
      h2 [class "title"] [text "Let's get started!"],
      form
        [onSubmit address Submit]
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
  case (model.board_size, model.signup_complete, model.board_chosen_externally) of
    (0, _, _) -> False
    (_, False, False) -> False
    (_, _, _) -> True

boardSizeSelector : Signal.Address Action -> Model -> Html
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

sizeSelector : Signal.Address Action -> Model -> Int -> Html
sizeSelector address model size =
  let chosenClass = if model.board_size == size then "chosen" else ""
  in
  a
    [ onClick address (ChooseSize size)
    , class chosenClass
    ]
    [text (formattedBoardSize size)]

formattedBoardSize : Int -> String
formattedBoardSize size =
  size
  |> toString
  |> List.repeat 2
  |> List.intersperse "x"
  |> List.foldr (++) ""

setPlayerName : String -> Action
setPlayerName fieldValue =
  UpdateName (trim fieldValue)

registrationSubmitDisabled : Model -> Attribute
registrationSubmitDisabled model =
  case (model.player_name, model.board_size) of
    (Nothing, _) -> disabled True
    (_, 0)       -> disabled True
    (_, _)       -> disabled False
