port module Test.Generated.Main644e3067db178574fd3fdba2f490dd6c exposing (main)

import Example
import MainTests
import ModelTests

import Test.Runner.Node
import Test
import Json.Encode

port emit : ( String, Json.Encode.Value ) -> Cmd msg

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "Example" [Example.suite],     Test.describe "MainTests" [MainTests.suite],     Test.describe "ModelTests" [ModelTests.suite] ]
        |> Test.concat
        |> Test.Runner.Node.runWithOptions { runs = Nothing, reporter = Nothing, seed = Nothing, paths = []} emit