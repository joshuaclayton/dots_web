module Hash where

import Native.Hash

md5 : String -> String
md5 name =
  Native.Hash.md5 name
