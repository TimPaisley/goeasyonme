module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Char
import Keyboard
import Http
import Json.Decode as Decode


{-| TODO: Split up into multiple modules
TODO: Find a better way to handle styling
TODO: Tests :(
-}
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


{-| How many incorrect guessed the player may try before they lose.
-}
chances =
    10


{-| All valid letters of the alphabet (in the absense of List.range)
-}
alphabet =
    [ 'a'
    , 'b'
    , 'c'
    , 'd'
    , 'e'
    , 'f'
    , 'g'
    , 'h'
    , 'i'
    , 'j'
    , 'k'
    , 'l'
    , 'm'
    , 'n'
    , 'o'
    , 'p'
    , 'q'
    , 'r'
    , 's'
    , 't'
    , 'u'
    , 'v'
    , 'w'
    , 'x'
    , 'y'
    , 'z'
    ]


type State
    = Playing
    | Won
    | Lost


type alias Letter =
    Char


type alias Model =
    { state : State
    , word : String
    , guesses : List Letter
    }


init : ( Model, Cmd Msg )
init =
    ( Model Playing "" [], getRandomWord )



-- UPDATE


type Msg
    = NewWord (Result Http.Error String)
    | Guess Keyboard.KeyCode


{-| Update method, called every time a message is received
TODO: Need a better way to handle all state possibilities.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewWord (Ok newWord) ->
            ( { model | word = newWord }, Cmd.none )

        NewWord (Err err) ->
            -- TODO: Not sure how to handle this...
            ( model, Cmd.none )

        Guess code ->
            let
                newModel =
                    { model | guesses = (addKeyCodeToGuesses model code) }
            in
                -- TODO: This is pretty messy, need a better way to do this
                if model.state == Won || model.state == Lost then
                    ( model, Cmd.none )
                else if gameWon newModel then
                    ( { newModel | state = Won }, Cmd.none )
                else if gameLost newModel then
                    ( { newModel | state = Lost }, Cmd.none )
                else
                    ( newModel, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Keyboard.downs Guess



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ div [ class "chances" ] [ chancesView model ]
        , div [ class "correctGuesses" ] [ correctGuessesView model ]
        , div [ class "stateMessage" ] [ gameStateView model ]
        , div [ class "incorrectGuesses" ] [ incorrectGuessesView model ]
        , div [ class "footer" ] [ text "Drawings by Henrik Hedlund" ]
        ]



-- VIEW HELPERS


chancesView : Model -> Html msg
chancesView model =
    let
        chancesRemaining =
            chances - List.length (incorrectGuesses model)
    in
        img [ src (hangmanPictureFilename chancesRemaining) ] []


correctGuessesView : Model -> Html msg
correctGuessesView model =
    let
        formattedWord =
            List.map (formatLetter model) (String.toList model.word)
    in
        if model.state == Playing then
            text (String.fromList formattedWord)
        else
            text model.word


incorrectGuessesView : Model -> Html msg
incorrectGuessesView model =
    let
        allIncorrectGuesses =
            incorrectGuesses model
    in
        text (String.fromList allIncorrectGuesses)


gameStateView : Model -> Html msg
gameStateView model =
    let
        message =
            case model.state of
                Playing ->
                    "Press any key to make a guess."

                Won ->
                    "Congratulations, you won!"

                Lost ->
                    "You lose!"
    in
        text message



-- MISC HELPERS


{-| Uses a SetSetGo API to fetch a random word, of particular length if
defined by the model.
-}
getRandomWord : Cmd Msg
getRandomWord =
    let
        url =
            "http://api.wordnik.com:80/v4/words.json/randomWords?hasDictionaryDef=true&excludePartOfSpeech=proper-noun&minCorpusCount=100000&maxCorpusCount=-1&minDictionaryCount=1&maxDictionaryCount=-1&minLength=0&maxLength=-1&limit=1&api_key=a2a73e7b926c924fad7001ca3111acd55af2ffabf50eb4ae5"

        request =
            Http.get url decodeRandomWordUrl
    in
        Http.send NewWord request


{-| Decodes the Wordnik API response.
-}
decodeRandomWordUrl : Decode.Decoder String
decodeRandomWordUrl =
    Decode.at [ "0" ] (Decode.field "word" Decode.string)


{-| Creates an image URL based on how many chances are remaining.
-}
hangmanPictureFilename : Int -> String
hangmanPictureFilename chancesRemaining =
    "./img/hangman_" ++ Basics.toString chancesRemaining ++ ".png"


{-| Returns an updated (or unchanged, if there was an invalid input) list of
guesses from the current model.
TODO: This is doing too much validation, both "is a letter" and "has
not been guessed before" should be broken out.
-}
addKeyCodeToGuesses : Model -> Keyboard.KeyCode -> List Letter
addKeyCodeToGuesses model keycode =
    let
        character =
            keyCodeToLower keycode
    in
        case character of
            Just letter ->
                if List.member letter model.guesses then
                    model.guesses
                else
                    model.guesses ++ [ letter ]

            Nothing ->
                model.guesses


{-| Returns all incorrect guesses that have been made so far.
-}
incorrectGuesses : Model -> List Letter
incorrectGuesses model =
    List.filter (notInWord model) model.guesses


{-| Returns true/false depending on whether a particular letter
is present within the target word.
TODO: Only used by incorrectGuesses, maybe not necessary.
-}
notInWord : Model -> Letter -> Bool
notInWord model letter =
    let
        wordLetters =
            String.toList model.word
    in
        not (List.member letter wordLetters)


{-| Returns a lowercase letter represented by the keycode, otherwise returns
a whitespace character if code in not a letter
TODO: Does two things - converts keycode to char and alphabet validation
-}
keyCodeToLower : Keyboard.KeyCode -> Maybe Letter
keyCodeToLower code =
    let
        character =
            Char.toLower (Char.fromCode code)
    in
        if List.member character alphabet then
            Just character
        else
            Nothing


{-| Returns the character to represent a letter in the target word,
depending on whether or not it has been guessed.
TODO: Maybe needs a better name,
-}
formatLetter : Model -> Letter -> Letter
formatLetter model letter =
    if List.member letter model.guesses then
        letter
    else
        '_'


{-| Returns a boolean that represents whether the game has been won, based
on if all letters in the target word have been guessed.
-}
gameWon : Model -> Bool
gameWon model =
    List.all (\letter -> List.member letter model.guesses) (String.toList model.word)


gameLost : Model -> Bool
gameLost model =
    chances - (List.length (incorrectGuesses model)) <= 0
