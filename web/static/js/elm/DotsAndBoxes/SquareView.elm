module DotsAndBoxes.SquareView (square) where

import Html exposing (..)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)
import Signal exposing (Address)
import DotsAndBoxes.Model exposing (isCurrentPlayer, Action, Model, Square, SquareSide, Claim)

square : Address Action -> Model -> Square -> Html
square address model square' =
  ul
    [class "square"]
    (List.map (squareSide address model square') sides)

squareSide : Address Action -> Model -> Square -> SquareSide -> Html
squareSide address model square side =
  let claimedSides = List.map .position square.claims
  in
    li [ classList [(sideToString side, True), ("claimed", isSideClaimed claimedSides side)]
    , onClick address (actionBasedOnTurn model square side)
    ] []

actionBasedOnTurn : Model -> Square -> SquareSide -> Action
actionBasedOnTurn model square side =
  case isCurrentPlayer model of
    True -> DotsAndBoxes.Model.ClaimSide square side
    False -> DotsAndBoxes.Model.NoOp

isSideClaimed : List SquareSide -> SquareSide -> Bool
isSideClaimed claims side =
  List.member side claims

sides : List SquareSide
sides =
  [ DotsAndBoxes.Model.Top
  , DotsAndBoxes.Model.Right
  , DotsAndBoxes.Model.Bottom
  , DotsAndBoxes.Model.Left
  ]

sideToString : SquareSide -> String
sideToString side =
  case side of
    DotsAndBoxes.Model.Top -> "side-top"
    DotsAndBoxes.Model.Right -> "side-right"
    DotsAndBoxes.Model.Bottom -> "side-bottom"
    DotsAndBoxes.Model.Left -> "side-left"
    _ -> ""