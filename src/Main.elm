module Main where

import Debug
import UI exposing (..)
import Schema exposing (..)
import Markov exposing (..)
import Html exposing (..)
import Http exposing (..)
import Signal exposing (..)
import Json.Decode as Json

newsStories : Signal (Response (List NewsItem))
newsStories = Signal.map (Http.mapResult <| Json.decodeString decodeNewsItems)
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
    Reset -> {model | phrase <- [startToken]}
    LoadNews response -> {model | graph <- graphFromNews response
                                , newsItems <- response}
    ChooseToken s -> let currentPhrase = model.phrase
                     in {model | phrase <- currentPhrase ++ [s]}

initialModel : Model
initialModel =
  {newsItems = NotAsked
  ,graph = Nothing
  ,phrase = [startToken]}

model : Signal Model
model = foldp step
              initialModel
              (mergeMany [uiMailbox.signal
                         ,LoadNews <~ newsStories])

uiMailbox : Mailbox Action
uiMailbox = Signal.mailbox NoOp

main : Signal Html
main = rootView uiMailbox.address <~ model
