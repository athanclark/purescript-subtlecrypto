{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "subtlecrypto"
, dependencies =
  [ "aff"
  , "aff-promise"
  , "arraybuffer"
  , "arraybuffer-types"
  , "console"
  , "effect"
  , "either"
  , "exceptions"
  , "foreign"
  , "functions"
  , "maybe"
  , "prelude"
  , "transformers"
  , "tuples"
  , "unsafe-coerce"
  , "web-encoding"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
