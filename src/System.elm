module System where

import Http exposing (..)

type alias Model =
  {newsIds : Response (List Int)}

type Action = NoOp
            | NewsIds (Response (List Int))
