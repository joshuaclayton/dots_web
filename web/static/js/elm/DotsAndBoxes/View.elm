module DotsAndBoxes.View where

import Html exposing (..)
import Html.Attributes exposing (class, type', value)
import Signal exposing (Address)
import DotsAndBoxes.Model exposing (Action, Model)
import DotsAndBoxes.RegistrationView exposing (registrationView)
import DotsAndBoxes.PendingImplementationView exposing (pendingImplementationView)
import DotsAndBoxes.ScoreView exposing (scoreView)
import DotsAndBoxes.PlayersView exposing (playersList)
import DotsAndBoxes.BoardView exposing (board)
import DotsAndBoxes.CustomEvent exposing (onSubmit)

mainView : Address Action -> Model -> Html
mainView address model =
  case model.lobby.status of
    DotsAndBoxes.Model.Unknown -> loadingView
    DotsAndBoxes.Model.NotStarted -> notStartedView address model
    DotsAndBoxes.Model.Started -> startedView address model

loadingView : Html
loadingView =
  section
    [class "modal loading"]
    [h2 [] [text "Loading the game..."]]

notStartedView : Address Action -> Model -> Html
notStartedView address model =
  case model.player of
    Nothing -> registrationView address model
    _ -> waitingForOtherPlayersView address model

startedView : Address Action -> Model -> Html
startedView address model =
  case model.lobby.game.completed of
    True -> scoreView model.lobby.game.score
    False -> board address model

waitingForOtherPlayersView : Address Action -> Model -> Html
waitingForOtherPlayersView address model =
  section
    [class "modal"]
    [ playersList model.lobby.game.players
    , startGameForm address
    ]

startGameForm : Address Action -> Html
startGameForm address =
  form
    [onSubmit address DotsAndBoxes.Model.StartGame]
    [ ul
      []
      [
        li [] [
          input [type' "submit", value "Start the game"] []
        ]
      ]
    ]
