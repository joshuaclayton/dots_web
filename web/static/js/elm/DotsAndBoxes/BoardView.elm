module DotsAndBoxes.BoardView (board) where

import Html exposing (..)
import Html.Attributes exposing (class)
import Signal exposing (Address)
import DotsAndBoxes.Model exposing (Action, Model)
import DotsAndBoxes.PlayersView exposing (playersList)
import DotsAndBoxes.TurnDesignatorView exposing (turnDesignator)

board : Address Action -> Model -> Html
board address model =
  section
    [class "full-board"]
    [ playersList model.lobby.game.players
    , turnDesignator model
    ]
