module DotsAndBoxes.View (mainView) where

import Html exposing (..)
import Html.Attributes exposing (class, type', value, disabled)
import Signal exposing (Address)
import DotsAndBoxes.Model exposing (..)
import DotsAndBoxes.PendingImplementationView exposing (pendingImplementationView)
import DotsAndBoxes.ScoreView exposing (scoreView)
import DotsAndBoxes.PlayersView exposing (playersList)
import DotsAndBoxes.BoardView exposing (board)
import DotsAndBoxes.CustomEvent exposing (onSubmit)
import DotsAndBoxes.PlayerRegistration

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
    Nothing -> DotsAndBoxes.PlayerRegistration.view (Signal.forwardTo address HandlePlayerRegistration) model.registration
    _ -> waitingForOtherPlayersView address model

startedView : Address Action -> Model -> Html
startedView address model =
  case model.lobby.game.completed of
    True -> scoreView address model.lobby.game.score
    False -> board address model

waitingForOtherPlayersView : Address Action -> Model -> Html
waitingForOtherPlayersView address model =
  section
    [class "modal"]
    [ p [] [text "Share this URL with your friends so they can get in on the action!"]
    , playersList model.lobby.game.players
    , startGameForm address model.lobby.game.players
    ]

startGameForm : Address Action -> List Player -> Html
startGameForm address players =
  let ableToStartGame = List.length players > 1
      buttonText = if ableToStartGame then "Start the game" else "Waiting for more players"
  in
  form
    [onSubmit address DotsAndBoxes.Model.StartGame]
    [ ul
      []
      [
        li [] [
          input [type' "submit", value buttonText, disabled (not ableToStartGame)] []
        ]
      ]
    ]
