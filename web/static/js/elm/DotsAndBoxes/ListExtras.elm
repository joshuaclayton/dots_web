module DotsAndBoxes.ListExtras (values, groupBy) where

import Set exposing (toList, fromList)

values : List (a, b) -> List b
values groupedList =
  List.map (\(_, values) -> values) groupedList

groupBy : (a -> comparable) -> List a -> List (comparable, List a)
groupBy grouping list =
  let uniqueValues = (List.map grouping list) |> fromList |> toList
  in
     List.map (\value ->
       (value, List.filter (\i -> grouping i == value) list)
     ) uniqueValues
