module Main where

import Debug
import UI exposing (..)
import System exposing (..)
import Html exposing (..)
import Http exposing (..)
import Signal exposing (..)
import Json.Decode as Json

decodeFeed : String -> Result String (List NewsItem)
decodeFeed = Json.decodeString decodeNewsItems

newsStories : Signal (Response (List NewsItem))
newsStories = Signal.map (Http.mapResult decodeFeed)
                         (Http.sendGet <| constant "http://hn.algolia.com/api/v1/search_by_date?tags=story&hitsPerPage=200")

graphFromNews : Response (List NewsItem) -> Maybe Graph
graphFromNews r =
  case r of
    Success items -> Just (createGraph (List.map .title items))
    _ -> Nothing

------------------------------------------------------------
step : Action -> Model -> Model
step action model =
  case action of
    NoOp -> model
    LoadNews response -> {model | graph <- graphFromNews response
                                , newsItems <- response}

initialModel : Model
initialModel =
  {newsItems = NotAsked
  ,graph = Nothing}

model : Signal Model
model = foldp step
              initialModel
              (mergeMany [uiMailbox.signal
                         ,LoadNews <~ newsStories])

uiMailbox : Mailbox Action
uiMailbox = Signal.mailbox NoOp

main : Signal Html
main = rootView uiMailbox.address <~ model
