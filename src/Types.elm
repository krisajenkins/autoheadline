module Types exposing (..)

import Http exposing (Error)
import Markov exposing (..)


type alias NewsItem =
    { title : String }


graphFromNews : List NewsItem -> Graph String
graphFromNews =
    List.map .title >> createGraph


type alias Model =
    { newsItems : Maybe (Result Error (List NewsItem))
    , phrase : List Token
    }


type Msg
    = LoadNews (Result Error (List NewsItem))
    | ChooseToken String
    | Reset
