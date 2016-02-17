module DotsAndBoxes.TurnDesignatorView (turnDesignator) where

import Html exposing (..)
import Html.Attributes exposing (class)
import DotsAndBoxes.Model exposing (nullPlayer, isCurrentPlayer, Model)

turnDesignator : Model -> Html
turnDesignator model =
  p [] [text ("It's " ++ currentPlayerName model ++ " turn")]

currentPlayerName : Model -> String
currentPlayerName model =
  case isCurrentPlayer model of
    True -> "your"
    False -> model.lobby.game.current_player.name ++ "'s"
