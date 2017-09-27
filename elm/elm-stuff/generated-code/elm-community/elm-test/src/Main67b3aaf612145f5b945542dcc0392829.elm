port module Test.Generated.Main67b3aaf612145f5b945542dcc0392829 exposing (main)

import Main
import Model

import Test.Runner.Node
import Test
import Json.Encode

port emit : ( String, Json.Encode.Value ) -> Cmd msg

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "Main" [Main.suite],     Test.describe "Model" [Model.suite] ]
        |> Test.concat
        |> Test.Runner.Node.runWithOptions { runs = Nothing, reporter = Nothing, seed = Nothing, paths = []} emit