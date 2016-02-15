module DotsAndBoxes.ScoreView (scoreView) where

import Html exposing (..)
import Html.Attributes exposing (class)
import DotsAndBoxes.Model exposing (Score)

scoreView : Score -> Html
scoreView score =
  section [class "modal"] [ h2 [] [text "Winner: ", winnersList score]
  ]

winnersList : Score -> Html
winnersList score =
  let winnerNames = List.map .name score.winners
  in
    text (winnerNames |> List.foldr (++) "")
