module Markov (..) where

import Dict exposing (Dict)
import Set exposing (Set)
import String exposing (words)


type alias Token =
  String


type alias Graph =
  Dict Token (Set Token)


type alias Sentence =
  List Token


startToken : String
startToken =
  "START"


endToken : String
endToken =
  "END"


toSentence : String -> Sentence
toSentence s =
  [ startToken ] ++ (words s) ++ [ endToken ]


addLink : ( Token, Token ) -> Graph -> Graph
addLink ( from, to ) graph =
  let
    updater =
      Just << Set.insert to << Maybe.withDefault Set.empty
  in
    Dict.update from updater graph


addSentence : String -> Graph -> Graph
addSentence s g =
  let
    sentence =
      toSentence s

    pairs =
      List.map2 (,) sentence (Maybe.withDefault [] (List.tail sentence))
  in
    List.foldl addLink g pairs


initialGraph : Graph
initialGraph =
  Dict.empty


createGraph : List String -> Graph
createGraph =
  List.foldl addSentence initialGraph
