module Main where

import Debug
import UI exposing (..)
import System exposing (..)
import Html exposing (..)
import Http exposing (..)
import Signal exposing (..)
import Json.Decode as Json

decodeIntList : String -> Result String (List Int)
decodeIntList = Json.decodeString (Json.list Json.int)

newsStoryIdsRaw : Signal (Response String)
newsStoryIdsRaw = Http.sendGet <| constant "https://hacker-news.firebaseio.com/v0/newstories.json"

newsStoryIds : Signal (Response (List Int))
newsStoryIds = Http.mapResult decodeIntList <~ newsStoryIdsRaw

------------------------------------------------------------
step : Action -> Model -> Model
step action model =
  case action of
    NoOp -> model
    NewsIds response -> {model | newsIds <- response}

initialModel : Model
initialModel =
  {newsIds = NotAsked}

model : Signal Model
model = foldp step
              initialModel
              (mergeMany [uiMailbox.signal
                         ,NewsIds <~ newsStoryIds])

uiMailbox : Mailbox Action
uiMailbox = Signal.mailbox NoOp

main : Signal Html
main = rootView uiMailbox.address <~ model
