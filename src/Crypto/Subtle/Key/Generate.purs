module Crypto.Subtle.Key.Generate
  ( generateKey, generateKeyPair
  , AsymmetricAlgorithm, rsa, ec
  , SymmetricAlgorithm, hmac, aes
  , exp65537
  ) where

import Crypto.Subtle.Key.Types (CryptoKey, CryptoKeyPair, CryptoKeyUsage)
import Crypto.Subtle.Hash (HashingFunction)
import Crypto.Subtle.Constants.RSA (RSAAlgorithm)
import Crypto.Subtle.Constants.EC (ECAlgorithm, ECCurve)
import Crypto.Subtle.Constants.AES (AESAlgorithm, AESBitLength)

import Prelude ((<<<), (<$))
import Data.Function.Uncurried (Fn3, runFn3)
import Data.ArrayBuffer.Types (Uint8Array)
import Data.Either (Either (..))
import Effect.Promise (Promise, runPromise)
import Effect.Aff (Aff, makeAff, nonCanceler)
import Unsafe.Coerce (unsafeCoerce)



foreign import generateKeyImpl :: forall a b. Fn3 a Boolean (Array CryptoKeyUsage) (Promise b)


-- | Generate a symmetric key
generateKey :: SymmetricAlgorithm
            -> Boolean -- ^ Extractable
            -> Array CryptoKeyUsage
            -> Aff CryptoKey
generateKey a e u = makeAff \resolve ->
  nonCanceler <$ runPromise (resolve <<< Right) (resolve <<< Left) (runFn3 generateKeyImpl a e u)

-- | Generate an asymmetric keypair
generateKeyPair :: AsymmetricAlgorithm
                -> Boolean -- ^ Extractable
                -> Array CryptoKeyUsage
                -> Aff CryptoKeyPair
generateKeyPair a e u = makeAff \resolve ->
  nonCanceler <$ runPromise (resolve <<< Right) (resolve <<< Left) (runFn3 generateKeyImpl a e u)


foreign import data SymmetricAlgorithm :: Type
foreign import data AsymmetricAlgorithm :: Type


foreign import exp65537 :: Uint8Array


rsa :: RSAAlgorithm
    -> Int -- ^ Modulus length. Should be at least 2048, or 4096 according to some bozo
    -> Uint8Array -- ^ Public exponent. Just use `exp65537`.
    -> HashingFunction
    -> AsymmetricAlgorithm
rsa r l e h = unsafeCoerce {name: r, modulusLength: l, publicExponent: e, hash: h}

ec :: ECAlgorithm -> ECCurve -> AsymmetricAlgorithm
ec e c = unsafeCoerce {name: e, namedCurve: c}

hmac :: HashingFunction -> SymmetricAlgorithm
hmac h = unsafeCoerce {name: "HMAC", hash: h}

aes :: AESAlgorithm
    -> AESBitLength
    -> SymmetricAlgorithm
aes a l = unsafeCoerce {name: a, length: l}
