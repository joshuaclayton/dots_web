module DotsAndBoxes.View where

import Html exposing (..)
import Html.Attributes exposing (..)

loadingView : Html
loadingView =
  section
    [class "modal"]
    [text "Loading game..."]
