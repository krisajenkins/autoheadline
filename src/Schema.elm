module Schema where

import Http exposing (Response)
import Json.Decode exposing (..)
import Markov exposing (Graph,Sentence)

type alias NewsItem =
  {title : String}

decodeNewsItem : Decoder NewsItem
decodeNewsItem = NewsItem `map` ("title" := string)

decodeNewsItems : Decoder (List NewsItem)
decodeNewsItems = at ["hits"] (list decodeNewsItem)

type alias Model =
  {newsItems : Response (List NewsItem)
  ,graph : Maybe Graph
  ,phrase : Sentence}

type Action
  = NoOp
  | LoadNews (Response (List NewsItem))
  | ChooseToken String
  | Reset
