module DotsAndBoxes.ScoreView (scoreView) where

import Html exposing (..)
import DotsAndBoxes.CustomEvent exposing (onSubmit)
import Html.Attributes exposing (class, value, type')
import DotsAndBoxes.Model exposing (..)

scoreView : Signal.Address Action -> Score -> Html
scoreView address score =
  section [class "modal"] [ h2 [] [text "Winner: ", winnersList score]
  , scoresBreakdown score.scores
  , playAgain address
  ]

playAgain : Signal.Address Action -> Html
playAgain address =
  form
    [onSubmit address PlayAgain]
    [
      ul
        []
        [
          li [] [
            input
              [type' "submit", value "Play another!"]
              []
          ]
        ]
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
