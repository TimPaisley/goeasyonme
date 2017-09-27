port module Test.Generated.Main6f16e0f74ad6bb984b7fe245e4641b20 exposing (main)

import ModelTests

import Test.Runner.Node
import Test
import Json.Encode

port emit : ( String, Json.Encode.Value ) -> Cmd msg

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "ModelTests" [ModelTests.gameLost,
    ModelTests.gameWon] ]
        |> Test.concat
        |> Test.Runner.Node.runWithOptions { runs = Nothing, reporter = Nothing, seed = Nothing, paths = []} emit