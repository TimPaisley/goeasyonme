module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (id, class)
import Svg exposing (svg)
import Svg.Events exposing (onClick)
import Svg.Attributes exposing (width, height, r, cx, cy, fill)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type State
    = Playing
    | Won
    | Lost


type Player
    = White
    | Black


type Intersection
    = Just Player
    | Nothing


type alias Model =
    { state : State
    , turn : Player
    , board : List Intersection
    }


boardSize : Int
boardSize =
    9


init : ( Model, Cmd Msg )
init =
    ( Model Playing Black (List.repeat (boardSize * boardSize) Nothing)
    , Cmd.none
    )



-- UPDATE


type Msg
    = PlaceStone


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PlaceStone ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ header
        , boardView model.board
        ]


header : Html Msg
header =
    div [ id "header" ]
        [ h1 [] [ text "GO" ]
        , h2 [] [ text "(Easy on Me)" ]
        ]


boardView : List Intersection -> Html Msg
boardView board =
    let
        positions =
            List.indexedMap intersectionToGrid board

        stones =
            List.map stone positions

        svgWidth =
            stoneRadius * boardSize * 2
    in
        div [ id "board" ]
            [ svg [ width (toString svgWidth), height (toString svgWidth) ] stones
            ]


intersectionToGrid : Int -> Intersection -> ( Int, Int )
intersectionToGrid index _ =
    let
        x =
            index % boardSize

        y =
            index // boardSize
    in
        ( x, y )


stoneRadius : Int
stoneRadius =
    15


stone : ( Int, Int ) -> Svg.Svg Msg
stone ( xCenter, yCenter ) =
    Svg.circle
        [ r (toString stoneRadius)
        , fill "black"
        , cy (toString (stoneRadius + xCenter * stoneRadius * 2))
        , cx (toString (stoneRadius + yCenter * stoneRadius * 2))
        ]
        []
