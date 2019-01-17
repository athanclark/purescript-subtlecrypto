module Crypto.Subtle.Sign
  ( sign, verify
  , SignAlgorithm, rsaPKCS1, rsaPSS, ecdsa, hmac
  ) where

import Crypto.Subtle.Key.Types (CryptoKey)
import Crypto.Subtle.Hash (HashingFunction)

import Prelude ((<<<), (<$))
import Data.Function.Uncurried (Fn3, Fn4, runFn3, runFn4)
import Data.Either (Either (..))
import Data.ArrayBuffer.Types (ArrayBuffer)
import Effect.Promise (Promise, runPromise)
import Effect.Aff (Aff, makeAff, nonCanceler)
import Unsafe.Coerce (unsafeCoerce)



foreign import data SignAlgorithm :: Type

rsaPKCS1 :: SignAlgorithm
rsaPKCS1 = unsafeCoerce {name: "RSASSA-PKCS1-v1_5"}

rsaPSS :: Int -- ^ Salt length
       -> SignAlgorithm
rsaPSS l = unsafeCoerce {name: "RSA-PSS", saltLength: l}

ecdsa :: HashingFunction
      -> SignAlgorithm
ecdsa h = unsafeCoerce {name: "ECDSA", hash: h}

hmac :: SignAlgorithm
hmac = unsafeCoerce {name: "HMAC"}


foreign import signImpl :: Fn3 SignAlgorithm CryptoKey ArrayBuffer (Promise ArrayBuffer)

sign :: SignAlgorithm
     -> CryptoKey
     -> ArrayBuffer
     -> Aff ArrayBuffer
sign a k x = makeAff \resolve ->
  nonCanceler <$ runPromise (resolve <<< Right) (resolve <<< Left) (runFn3 signImpl a k x)


foreign import verifyImpl :: Fn4 SignAlgorithm CryptoKey ArrayBuffer ArrayBuffer (Promise Boolean)

verify :: SignAlgorithm
       -> CryptoKey
       -> ArrayBuffer -- ^ Signature
       -> ArrayBuffer -- ^ Subject data
       -> Aff Boolean
verify a k s x = makeAff \resolve ->
  nonCanceler <$ runPromise (resolve <<< Right) (resolve <<< Left) (runFn4 verifyImpl a k s x)
