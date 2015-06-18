module UI where

import String
import Html exposing (..)
import Http exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (..)
import Dict
import Set
import System exposing (..)

rootView : Address Action -> Model -> Html
rootView uiChannel model =
  div [class "container"]
      [div [class "row"]
           [div [class "col-xs-12"]
                [body uiChannel model]]]

itemView : NewsItem -> Html
itemView item =
  div [] [text item.title]

tokenButton : Address Action -> String -> Html
tokenButton uiChannel token =
  button [class "btn btn-info"
         ,onClick uiChannel (ChooseToken token)]
         [text token]

tokenButtons : Address Action -> List String -> Html
tokenButtons uiChannel tokens =
  div []
      (List.map (tokenButton uiChannel) tokens)

body : Address Action -> Model -> Html
body uiChannel model =
  let currentToken = Maybe.withDefault "START" (List.head (List.reverse model.phrase))
      nextTokens = Dict.get currentToken (Maybe.withDefault Dict.empty model.graph)
  in div []
         [h1 []
             [text "News"]
         ,h2 [] [text <| String.join " " model.phrase]
         ,button [class "btn btn-warning"
                 ,onClick uiChannel Reset]
                 [text "Reset!"]
         ,case nextTokens of
            Nothing -> div [] []
            Just ts -> tokenButtons uiChannel (Set.toList ts)
         ,case model.newsItems of
            Success (items) -> div [] (List.map itemView items)
            _ -> code [] [text <| toString model.newsItems]
         ,div [] [code [] [text <| toString model.graph]]]
