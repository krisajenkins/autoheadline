module State (..) where

import Effects exposing (Effects, Never, none)
import Types exposing (..)
import Markov exposing (..)
import Rest exposing (loadNewsStories)


initialPhrase : List String
initialPhrase =
  [ startToken ]


initialState : ( Model, Effects Action )
initialState =
  ( { newsItems = Nothing
    , phrase = initialPhrase
    }
  , Effects.map LoadNews loadNewsStories
  )


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    Reset ->
      ( { model | phrase = initialPhrase }
      , none
      )

    LoadNews response ->
      ( { model | newsItems = Just response }
      , none
      )

    ChooseToken s ->
      ( { model | phrase = model.phrase ++ [ s ] }
      , none
      )
