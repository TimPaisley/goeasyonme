module Main exposing (..)

import Html
import Char
import Set exposing (..)
import Http

import Model exposing (..)
import Update
import Subscriptions
import View

main =
  Html.program
    { init = ( Model.initial, Model.getRandomWord )
    , view = View.view
    , update = Update.update
    , subscriptions = Subscriptions.subscriptions
    }
