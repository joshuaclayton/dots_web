module DotsAndBoxes.PlayersView where

import Html exposing (..)
import Html.Attributes exposing (class)
import DotsAndBoxes.Model exposing (Player)

playersList : List Player -> Html
playersList players =
  section
    [class "players-list"]
    [ h2 [] [text "Players"]
    , ul [] (List.map (\player -> li [] [text player.name]) players)
    ]
