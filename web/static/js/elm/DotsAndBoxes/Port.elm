module DotsAndBoxes.Port (fromPort) where

fromPort : (a -> b) -> Signal a -> Signal b
fromPort action inboundPort =
  (Signal.map <| action) inboundPort
