module UI where

import Html exposing (..)
import Http exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (..)
import System exposing (..)

rootView : Address Action -> Model -> Html
rootView uiChannel model =
  div [class "container"]
      [div [class "row"]
           [div [class "col-xs-12"]
                [body model]]]

itemView : NewsItem -> Html
itemView item =
  div [] [text item.title]

body : Model -> Html
body model =
  div []
      [h1 []
          [text "News"]
      ,div [] [code [] [text <| toString model.graph]]
      ,case model.newsItems of
         Success (items) -> div [] (List.map itemView items)
         _ -> code [] [text <| toString model.newsItems]]
