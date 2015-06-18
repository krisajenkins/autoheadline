module System where

import Http exposing (Response)
import Json.Decode exposing (..)
import Json.Decode.Extra exposing (apply)
import Dict exposing (Dict)
import Set exposing (Set)
import String exposing (words)

type alias Token = String
type alias Graph = Dict Token (Set Token)
type alias Sentence = List Token

toSentence : String -> Sentence
toSentence s = ["START"] ++ (words s) ++ ["END"]

foldGraph : Graph -> (a -> Graph -> Graph) -> List a -> Graph
foldGraph g f xs =
  case xs of
    [] -> g
    (y::ys) -> foldGraph (f y g) f ys

addPair : (Token,Token) -> Graph -> Graph
addPair (from,to) g =
  let updater m = case m of
                    Nothing -> Just (Set.singleton to)
                    Just vs -> Just (Set.insert to vs)
  in Dict.update from updater g

addChain : String -> Graph -> Graph
addChain s g =
  let sentence = toSentence s
      pairs = List.map2 (,) sentence (Maybe.withDefault [] (List.tail sentence))
  in foldGraph g addPair pairs

initialGraph : Graph
initialGraph = Dict.empty

createGraph : List String -> Graph
createGraph = List.foldl addChain initialGraph

type alias NewsItem =
  {title : String}

decodeNewsItem : Decoder NewsItem
decodeNewsItem = NewsItem `map` ("title" := string)

decodeNewsItems : Decoder (List NewsItem)
decodeNewsItems = at ["hits"] (list decodeNewsItem)

type alias Model =
  {newsItems : Response (List NewsItem)
  ,graph : Maybe Graph}

type Action = NoOp
            | LoadNews (Response (List NewsItem))
