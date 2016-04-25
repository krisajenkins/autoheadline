module Markov (..) where

import Dict exposing (Dict)
import Set exposing (Set)
import String exposing (words)


type alias Token =
  String


type alias Graph comparable =
  Dict comparable (Set comparable)


startToken : String
startToken =
  "START"


endToken : String
endToken =
  "END"


type alias Edge a =
  { from : a
  , to : a
  }


toSentence : String -> List Token
toSentence s =
  [ startToken ] ++ (words s) ++ [ endToken ]


addLink : Edge comparable -> Graph comparable -> Graph comparable
addLink edge graph =
  let
    updater =
      Just
        << Set.insert edge.to
        << Maybe.withDefault Set.empty
  in
    Dict.update edge.from updater graph


addSentence : Token -> Graph Token -> Graph Token
addSentence s g =
  let
    sentence =
      toSentence s

    pairs =
      List.map2
        Edge
        sentence
        (Maybe.withDefault [] (List.tail sentence))
  in
    List.foldl addLink g pairs


initialGraph : Graph n
initialGraph =
  Dict.empty


createGraph : List Token -> Graph Token
createGraph =
  List.foldl addSentence initialGraph
