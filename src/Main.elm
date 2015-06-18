module Main where

import Debug
import UI exposing (..)
import System exposing (..)
import Html exposing (..)
import Signal exposing (..)

step : Action -> Model -> Model
step action model = model

initialModel : Model
initialModel = {}

model : Signal Model
model = foldp step
              initialModel
              (mergeMany [uiMailbox.signal])

uiMailbox : Mailbox Action
uiMailbox = Signal.mailbox NoOp

main : Signal Html
main = rootView uiMailbox.address <~ model
