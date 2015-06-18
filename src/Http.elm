module Http
    ( send, sendGet
    , get, post, request
    , Response(..), Request
    , isSuccess
    , map, mapResult, mappend
    ) where

{-| A library for asynchronous HTTP requests. See the `WebSocket`
library if you have very strict latency requirements.

# Sending Requests
@docs send, sendGet

# Creating Requests
@docs get, post, request

# Responses
@docs Response
-}

import Signal exposing (Signal)
import Signal
import Native.Http

{-| The datatype for responses. Success contains only the returned message.
Failures contain both an error code and an error message.
-}
type Response a
    = NotAsked
    | Waiting
    | Success a
    | Failure Int String

type alias Request a =
    { verb : String
    , url  : String
    , body : a
    , headers : List (String,String)
    }

{-| Create a customized request. Arguments are request type (get, post, put,
delete, etc.), target url, data, and a list of additional headers.
-}
request : String -> String -> String -> List (String,String) -> Request String
request = Request

{-| Create a GET request to the given url. -}
get : String -> Request String
get url = Request "GET" url "" []

{-| Create a POST request to the given url, carrying the given data. -}
post : String -> String -> Request String
post url body = Request "POST" url body []

{-| Performs an HTTP request with the given requests. Produces a signal
that carries the responses.
-}
send : Signal (Request a) -> Signal (Response String)
send = Native.Http.send

{-| Performs an HTTP GET request with the given urls. Produces a signal
that carries the responses.
-}
sendGet : Signal String -> Signal (Response String)
sendGet requestStrings =
    send (Signal.map get requestStrings)

map : (a -> b) -> Response a -> Response b
map f r =
  case r of
    NotAsked -> NotAsked
    Waiting -> Waiting
    Success x -> Success (f x)
    Failure code error -> Failure code error

mapResult : (a -> Result String b) -> Response a -> Response b
mapResult f r =
  case r of
    NotAsked -> NotAsked
    Waiting -> Waiting
    Success x -> case f x of
                   Ok o -> Success o
                   Err e -> Failure 0 e
    Failure code error -> Failure code error

mappend : Response a -> Response b -> Response (a,b)
mappend x y =
  case (x,y) of
    (NotAsked,_) -> NotAsked
    (_,NotAsked) -> NotAsked
    (Failure i e,_) -> Failure i e
    (_,Failure i e) -> Failure i e
    (Success x',Success y') -> Success (x',y')
    (_,_) -> Waiting

isSuccess : Response a -> Bool
isSuccess r =
  case r of
    Success _ -> True
    _ -> False
