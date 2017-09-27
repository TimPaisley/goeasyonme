port module Test.Generated.Mainca1f687daf4c0caf2e2dc05d09853c79 exposing (main)

import MainTests
import ModelTests

import Test.Runner.Node
import Test
import Json.Encode

port emit : ( String, Json.Encode.Value ) -> Cmd msg

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "MainTests" [MainTests.suite],     Test.describe "ModelTests" [ModelTests.suite] ]
        |> Test.concat
        |> Test.Runner.Node.runWithOptions { runs = Nothing, reporter = Nothing, seed = Nothing, paths = []} emit