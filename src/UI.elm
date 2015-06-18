module UI where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (..)
import System exposing (..)

rootView : Address Action -> Model -> Html
rootView uiChannel model =
  div [class "container"]
      [div [class "row"]
           [div [class "col-xs-12"]
                [body]]]

body : Html
body = h1 [] [text "Hello world"]
