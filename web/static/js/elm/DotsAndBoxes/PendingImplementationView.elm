module DotsAndBoxes.PendingImplementationView where

import Html exposing (..)
import Html.Attributes exposing (class)
import DotsAndBoxes.Model exposing (Model)

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

separatedList : List String -> String
separatedList words =
  words
  |> List.intersperse ", "
  |> List.foldr (++) ""
