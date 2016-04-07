module Rest (..) where

import Task
import Effects exposing (Effects, Never, none)
import Types exposing (..)
import Http exposing (Error)
import Json.Decode exposing (..)


decodeNewsItem : Decoder NewsItem
decodeNewsItem =
  object1
    NewsItem
    ("title" := string)


decodeNewsItems : Decoder (List NewsItem)
decodeNewsItems =
  at
    [ "hits" ]
    (list decodeNewsItem)


loadNewsStories : Effects (Result Error (List NewsItem))
loadNewsStories =
  Http.get decodeNewsItems "https://hn.algolia.com/api/v1/search_by_date?tags=story&hitsPerPage=200"
    |> Task.toResult
    |> Effects.task
