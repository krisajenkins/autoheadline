module Markov where

import Dict exposing (Dict)
import Set exposing (Set)
import String exposing (words)

type alias Token = String
type alias Graph = Dict Token (Set Token)
type alias Sentence = List Token

startToken : String
startToken = "START"

endToken : String
endToken = "END"

toSentence : String -> Sentence
toSentence s = [startToken] ++ (words s) ++ [endToken]

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
  in List.foldl addPair g pairs

initialGraph : Graph
initialGraph = Dict.empty

createGraph : List String -> Graph
createGraph = List.foldl addChain initialGraph
