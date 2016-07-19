module State exposing (..)

import Markov exposing (..)
import Rest exposing (loadNewsStories)
import Types exposing (..)


initialPhrase : List String
initialPhrase =
    [ startToken ]


initialState : ( Model, Cmd Msg )
initialState =
    ( { newsItems = Nothing
      , phrase = initialPhrase
      }
    , Cmd.map LoadNews loadNewsStories
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Reset ->
            ( { model | phrase = initialPhrase }
            , Cmd.none
            )

        LoadNews response ->
            ( { model | newsItems = Just response }
            , Cmd.none
            )

        ChooseToken s ->
            ( { model | phrase = model.phrase ++ [ s ] }
            , Cmd.none
            )
