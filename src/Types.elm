module Types (..) where

import Http exposing (Error)
import Markov exposing (Graph, Sentence, createGraph)


type alias NewsItem =
  { title : String }


graphFromNews : List NewsItem -> Graph
graphFromNews =
  List.map .title >> createGraph


type alias Model =
  { newsItems : Maybe (Result Error (List NewsItem))
  , phrase : Sentence
  }


type Action
  = LoadNews (Result Error (List NewsItem))
  | ChooseToken String
  | Reset
