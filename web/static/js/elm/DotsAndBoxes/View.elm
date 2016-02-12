module DotsAndBoxes.View where

import Html exposing (..)
import Html.Attributes exposing (class)
import Signal exposing (Address)
import DotsAndBoxes.Model exposing (Action, Model)
import DotsAndBoxes.RegistrationView exposing (registrationView)

mainView : Address Action -> Model -> Html
mainView address model =
  case model.lobby.status of
    DotsAndBoxes.Model.Unknown -> loadingView
    DotsAndBoxes.Model.NotStarted -> notStartedView address model
    _ -> pendingImplementationView model

loadingView : Html
loadingView =
  section
    [class "modal"]
    [text "Loading the game..."]

notStartedView : Address Action -> Model -> Html
notStartedView address model =
  case model.player of
    Nothing -> registrationView address model
    _ -> pendingImplementationView model

separatedList : List String -> String
separatedList words =
  words
  |> List.intersperse ", "
  |> List.foldr (++) ""

pendingImplementationView : Model -> Html
pendingImplementationView model =
  let playerNames = (List.map .name model.lobby.game.players) |> separatedList
  in
  section
    [class "modal"]
    [ text ("Not yet implemented: " ++ toString model.game_id)
    , br [] []
    , text ("Player name: " ++ Maybe.withDefault "Not set" model.player_name)
    , br [] []
    , text ("Players present: " ++ playerNames)
    ]
