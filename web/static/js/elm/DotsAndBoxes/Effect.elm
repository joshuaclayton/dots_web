module DotsAndBoxes.Effect (noEffects) where

import Effects exposing (Effects)

noEffects : a -> (a, Effects b)
noEffects thing = (thing, Effects.none)
