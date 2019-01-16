module Crypto.Subtle.Hash (HashingFunction, sha1, sha256, sha384, sha512, digest) where

import Prelude ((<<<), (<$))
import Data.ArrayBuffer.Types (ArrayBuffer)
import Data.Function.Uncurried (Fn2, runFn2)
import Data.Either (Either (..))
import Effect.Promise (Promise, runPromise)
import Effect.Aff (Aff, makeAff, nonCanceler)



newtype HashingFunction = HashingFunction String

sha1 :: HashingFunction
sha1 = HashingFunction "SHA-1"

sha256 :: HashingFunction
sha256 = HashingFunction "SHA-256"

sha384 :: HashingFunction
sha384 = HashingFunction "SHA-384"

sha512 :: HashingFunction
sha512 = HashingFunction "SHA-512"


foreign import digestImpl :: Fn2 HashingFunction ArrayBuffer (Promise ArrayBuffer)


digest :: HashingFunction -> ArrayBuffer -> Aff ArrayBuffer
digest h x =
  let p = runFn2 digestImpl h x
  in  makeAff \resolve -> nonCanceler <$ runPromise (resolve <<< Right) (resolve <<< Left) p
