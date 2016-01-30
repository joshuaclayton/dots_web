module DotsAndBoxes.View where

import Html exposing (..)
import Html.Attributes exposing (class, for, type', value, id)

loadingView : Html
loadingView =
  section
    [class "modal"]
    [text "Loading game..."]

pendingImplementationView : Html
pendingImplementationView =
  section [class "modal"] [text "Not yet implemented"]

registrationView : Html
registrationView =
  section
    [class "registration modal"]
    [
      h2 [class "title"] [text "Let's get started!"],
      form [] [
        ul [] [
          li [] [
            label [for "player_name"] [text "First, what's your name?"],
            input [type' "text", id "player_name"] []
          ],
          li [] [
            label [for "board_size"] [text "Next, what board size do you prefer?"]
          ],
          li [] [
            input [type' "submit", value "Game on!"] []
          ]
        ]
      ]
    ]
