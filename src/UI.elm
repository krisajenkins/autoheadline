module UI where

import String
import Html exposing (..)
import Http exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (..)
import Dict
import Set
import Schema exposing (..)

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
             [text "Make Your Own HackerNews Headline"]
         ,h2 []
             [text " from the latest 200 stories."]
         ,div [class "row"]
              [div [class "col-xs-12 col-sm-8 col-sm-offset-2"]
                   [blockquote []
                               [h3 [] [text <| String.join " " model.phrase]]]]
         ,div [class "row"]
              [div [class "col-xs-12 col-sm-2 well"]
                   [text "Click any button to choose the next word."]
              ,div [class "col-xs-12 col-sm-8"]
                   [case nextTokens of
                      Nothing -> div [] []
                      Just ts -> tokenButtons uiChannel (Set.toList ts)]
              ,div [class "col-xs-12 col-sm-2"]
                   [button [class "btn btn-warning"
                           ,onClick uiChannel Reset]
                           [text "Reset!"]]]
         ,div [class "row"]
              [div [class "col-xs-12 col-sm-8 col-sm-offset-2"]
                   [case model.newsItems of
                      Success (items) -> div [] (List.map itemView items)
                      _ -> loading]]]

loading : Html
loading = div [class "loading"]
              [img [src "/loading_wheel.gif"
                   ,class "loading"]
                   []]
