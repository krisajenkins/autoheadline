module State where

import Task
import Effects exposing (Effects,Never,none)
import Types exposing (..)
import Markov exposing (..)
import Http exposing (..)

loadNewsStories : Effects (Result Error (List NewsItem))
loadNewsStories =
  Http.get decodeNewsItems "https://hn.algolia.com/api/v1/search_by_date?tags=story&hitsPerPage=200"
  |> Task.toResult
  |> Effects.task

graphFromNews : List NewsItem -> Graph
graphFromNews = List.map .title >> createGraph

update : Action -> Model -> Model
update action model =
  case action of
    Reset -> {model | phrase = initialPhrase}
    LoadNews response -> {model | newsItems = Just response}
    ChooseToken s -> let currentPhrase = model.phrase
                     in {model | phrase = currentPhrase ++ [s]}

effect : Action -> Model -> Effects Action
effect action model = none

initialPhrase : List String
initialPhrase = [startToken]

initialState : (Model, Effects Action)
initialState =
  ({newsItems = Nothing
   ,phrase = initialPhrase}
  ,Effects.map LoadNews loadNewsStories)
