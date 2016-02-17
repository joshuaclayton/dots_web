module DotsAndBoxes.BoardView (board) where

import Html exposing (..)
import Html.Attributes exposing (class)
import Signal exposing (Address)
import DotsAndBoxes.Model exposing (nullBoard, Action, Model, Square)
import DotsAndBoxes.PlayersView exposing (playersList)
import DotsAndBoxes.SquareView exposing (square)
import DotsAndBoxes.TurnDesignatorView exposing (turnDesignator)
import DotsAndBoxes.ListExtras exposing (values, groupBy)

board : Address Action -> Model -> Html
board address model =
  section
    [class "full-board"]
    [ playersList model.lobby.game.players
    , turnDesignator model
    , board' address model
    ]

board' : Address Action -> Model -> Html
board' address model =
  let board = Maybe.withDefault nullBoard model.lobby.game.board
  in
    section
      [class "board"]
      [
        div [] (List.map (squaresRow address model) (squaresGroups board.squares))
      ]

squaresRow : Address Action -> Model -> List Square -> Html
squaresRow address model squares =
  div [class "square-row"] (List.map (square address model) squares)

squaresGroups : List Square -> List (List Square)
squaresGroups squares =
  (groupBy (\square -> square.coordinates.y) squares)
  |> values
  |> List.reverse
