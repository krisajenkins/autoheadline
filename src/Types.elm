module Types where

import Http exposing (Error)
import Json.Decode exposing (..)
import Markov exposing (Graph,Sentence)

type alias NewsItem =
  {title : String}

decodeNewsItem : Decoder NewsItem
decodeNewsItem =
  object1 NewsItem
    ("title" := string)

decodeNewsItems : Decoder (List NewsItem)
decodeNewsItems =
  at ["hits"]
     (list decodeNewsItem)

type alias Model =
  {newsItems : Maybe (Result Error (List NewsItem))
  ,phrase : Sentence}

type Action
  = LoadNews (Result Error (List NewsItem))
  | ChooseToken String
  | Reset
