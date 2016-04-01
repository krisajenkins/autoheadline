module App (..) where

import UI exposing (rootView)
import Task
import Effects exposing (Effects, Never, none)
import StartApp exposing (App)
import Types exposing (Model)
import Html exposing (Html)
import State exposing (initialState, update, effect)


app : App Model
app =
  StartApp.start
    { init = initialState
    , view = rootView
    , update =
        \action model ->
          let
            newModel =
              update action model

            newEffects =
              effect action newModel
          in
            ( newModel, newEffects )
    , inputs = []
    }


main : Signal Html
main =
  app.html


port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
