module DotsAndBoxes.ScoreView (scoreView) where

import Html exposing (..)
import Html.Attributes exposing (class)
import DotsAndBoxes.Model exposing (Score, PlayerScore)

scoreView : Score -> Html
scoreView score =
  section [class "modal"] [ h2 [] [text "Winner: ", winnersList score]
  , scoresBreakdown score.scores
  ]

winnersList : Score -> Html
winnersList score =
  let winnerNames = List.map .name score.winners
  in
    text (winnerNames |> List.foldr (++) "")

scoresBreakdown : List PlayerScore -> Html
scoresBreakdown playerScores =
  dl [] (playerScores|> List.map scoreBreakdown |> List.concat)

scoreBreakdown : PlayerScore -> List Html
scoreBreakdown playerScore =
  [ dt [] [text playerScore.player.name]
  , dd [] [text (playerScore.score |> toString)]
  ]
