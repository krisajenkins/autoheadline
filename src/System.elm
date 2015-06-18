module System where

import Http exposing (Response)
import Json.Decode exposing (..)
import Json.Decode.Extra exposing (apply)

type alias NewsItem =
  {title : String}

decodeNewsItem : Decoder NewsItem
decodeNewsItem = NewsItem `map` ("title" := string)

decodeNewsItems : Decoder (List NewsItem)
decodeNewsItems = at ["hits"] (list decodeNewsItem)

type alias Model =
  {newsItems : Response (List NewsItem)}

type Action = NoOp
            | LoadNews (Response (List NewsItem))
