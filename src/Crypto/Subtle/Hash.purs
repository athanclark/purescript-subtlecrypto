module Crypto.Subtle.Hash (HashingFunction, sha1, sha256, sha384, sha512, digest) where

import Control.Promise (Promise, toAff')
import Crypto.Subtle.Key.Types (errorFromDOMException)
import Data.ArrayBuffer.Types (ArrayBuffer)
import Data.Function.Uncurried (Fn2, runFn2)
import Effect.Aff (Aff)
import Prelude (class Eq)



newtype HashingFunction = HashingFunction String

derive newtype instance eqHashingFunction :: Eq HashingFunction

sha1 :: HashingFunction
sha1 = HashingFunction "SHA-1"

sha256 :: HashingFunction
sha256 = HashingFunction "SHA-256"

sha384 :: HashingFunction
sha384 = HashingFunction "SHA-384"

sha512 :: HashingFunction
sha512 = HashingFunction "SHA-512"

foreign import digestImpl :: Fn2 HashingFunction ArrayBuffer (Promise ArrayBuffer)

-- | https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/digest
digest :: HashingFunction -> ArrayBuffer -> Aff ArrayBuffer
digest h x = toAff' errorFromDOMException (runFn2 digestImpl h x)
