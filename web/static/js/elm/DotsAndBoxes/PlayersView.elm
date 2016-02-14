module DotsAndBoxes.PlayersView (playersList) where

import Html exposing (..)
import Html.Attributes exposing (class)
import DotsAndBoxes.Model exposing (Player)

playersList : List Player -> Html
playersList players =
  section
    [class "players-list"]
    [ h2 [] [text "Players"]
    , ul [] (List.map player' players)
    ]

player' : Player -> Html
player' player =
  li [] [text (player.name ++ " " ++ activeFlag player)]

activeFlag : Player -> String
activeFlag player =
  if player.active then
     ""
    else
     "(inactive)"
