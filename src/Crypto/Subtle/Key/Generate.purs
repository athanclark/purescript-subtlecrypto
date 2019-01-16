module Crypto.Subtle.Key.Generate
  ( generateKey
  , GenerateAlgorithm, exp65537, rsa, ec, hmac, aes
  , AESBitLength, l128, l192, l256
  ) where

import Crypto.Subtle.Key.Types (CryptoKey, CryptoKeyUsage)
import Crypto.Subtle.Hash (HashingFunction)
import Crypto.Subtle.RSA (RSAAlgorithm)
import Crypto.Subtle.EC (ECAlgorithm, ECCurve)
import Crypto.Subtle.AES (AESAlgorithm)

import Prelude ((<<<), (<$))
import Data.Function.Uncurried (Fn3, runFn3)
import Data.ArrayBuffer.Types (Uint8Array)
import Data.Either (Either (..))
import Effect.Promise (Promise, runPromise)
import Effect.Aff (Aff, makeAff, nonCanceler)
import Unsafe.Coerce (unsafeCoerce)



foreign import generateKeyImpl :: Fn3 GenerateAlgorithm Boolean (Array CryptoKeyUsage) (Promise CryptoKey)


generateKey :: GenerateAlgorithm
            -> Boolean -- ^ Extractable
            -> Array CryptoKeyUsage
            -> Aff CryptoKey
generateKey a e u = makeAff \resolve ->
  nonCanceler <$ runPromise (resolve <<< Right) (resolve <<< Left) (runFn3 generateKeyImpl a e u)


foreign import data GenerateAlgorithm :: Type


foreign import exp65537 :: Uint8Array


rsa :: RSAAlgorithm
    -> Int -- ^ Modulus length. Should be at least 2048, or 4096 according to some bozo
    -> Uint8Array -- ^ Public exponent. Just use `exp65537`.
    -> HashingFunction
    -> GenerateAlgorithm
rsa r l e h = unsafeCoerce {name: r, modulusLength: l, publicExponent: e, hash: h}

ec :: ECAlgorithm -> ECCurve -> GenerateAlgorithm
ec e c = unsafeCoerce {name: e, namedCurve: c}

hmac :: HashingFunction -> GenerateAlgorithm
hmac h = unsafeCoerce {name: "HMAC", hash: h}


newtype AESBitLength = AESBitLength Int

l128 :: AESBitLength
l128 = AESBitLength 128
l192 :: AESBitLength
l192 = AESBitLength 192
l256 :: AESBitLength
l256 = AESBitLength 256


aes :: AESAlgorithm -> AESBitLength -> GenerateAlgorithm
aes a l = unsafeCoerce {name: a, length: l}
