{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "subtlecrypto"
, dependencies =
  [ "aff"
  , "arraybuffer-types"
  , "console"
  , "effect"
  , "foreign"
  , "prelude"
  , "promises"
  , "psci-support"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
