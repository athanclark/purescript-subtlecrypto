module Crypto.Subtle.Key.Derive
  ( deriveKey
  , deriveBits
  , DeriveAlgorithm, ec, hkdf, pbkdf2
  , DeriveTargetAlgorithm, hmac, aes
  ) where

import Crypto.Subtle.Key.Types (CryptoKey, CryptoKeyUsage)
import Crypto.Subtle.Hash (HashingFunction)
import Crypto.Subtle.EC (ECAlgorithm)
import Crypto.Subtle.AES (AESAlgorithm, AESBitLength)

import Prelude ((<<<), (<$))
import Data.Function.Uncurried (Fn3, Fn5, runFn3, runFn5)
import Data.ArrayBuffer.Types (ArrayBuffer)
import Data.Either (Either (..))
import Effect.Promise (Promise, runPromise)
import Effect.Aff (Aff, makeAff, nonCanceler)
import Unsafe.Coerce (unsafeCoerce)



foreign import deriveKeyImpl :: Fn5 DeriveAlgorithm CryptoKey DeriveTargetAlgorithm Boolean (Array CryptoKeyUsage) (Promise CryptoKey)
foreign import deriveBitsImpl :: Fn3 DeriveAlgorithm CryptoKey Int (Promise ArrayBuffer)


deriveKey :: DeriveAlgorithm
          -> CryptoKey -- ^ Base key
          -> DeriveTargetAlgorithm
          -> Boolean -- ^ Extractable
          -> Array CryptoKeyUsage
          -> Aff CryptoKey
deriveKey a k t e u = makeAff \resolve ->
  nonCanceler <$ runPromise (resolve <<< Right) (resolve <<< Left) (runFn5 deriveKeyImpl a k t e u)

deriveBits :: DeriveAlgorithm
           -> CryptoKey -- ^ Base key
           -> Int -- ^ Length in bits
           -> Aff ArrayBuffer
deriveBits a k l = makeAff \resolve ->
  nonCanceler <$ runPromise (resolve <<< Right) (resolve <<< Left) (runFn3 deriveBitsImpl a k l)


foreign import data DeriveAlgorithm :: Type
foreign import data DeriveTargetAlgorithm :: Type


ec :: ECAlgorithm
   -> CryptoKey -- ^ Public key of the other entity
   -> DeriveAlgorithm
ec e k = unsafeCoerce {name: e, public: k}

hkdf :: HashingFunction
     -> ArrayBuffer -- ^ Salt
     -> ArrayBuffer -- ^ Info
     -> DeriveAlgorithm
hkdf h s i = unsafeCoerce {name: "HKDF", hash: h, salt: s, info: i}

pbkdf2 :: HashingFunction
       -> ArrayBuffer -- ^ Salt
       -> Int -- ^ Iterations
       -> DeriveAlgorithm
pbkdf2 h s i = unsafeCoerce {name: "PBKDF2", hash: h, salt: s, iterations: i}




hmac :: HashingFunction -> DeriveTargetAlgorithm
hmac h = unsafeCoerce {name: "HMAC", hash: h}

aes :: AESAlgorithm -> AESBitLength -> DeriveTargetAlgorithm
aes a l = unsafeCoerce {name: a, length: l}
