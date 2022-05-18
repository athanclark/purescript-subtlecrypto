module Crypto.Subtle.Key.Generate
  ( generateKey, generateKeyPair
  , AsymmetricAlgorithm, rsa, ec
  , SymmetricAlgorithm, hmac, aes
  , exp65537
  ) where

import Control.Promise (Promise, toAff')
import Crypto.Subtle.Constants.AES (AESAlgorithm, AESBitLength)
import Crypto.Subtle.Constants.EC (ECAlgorithm, ECCurve)
import Crypto.Subtle.Constants.RSA (RSAAlgorithm)
import Crypto.Subtle.Hash (HashingFunction)
import Crypto.Subtle.Key.Types (CryptoKey, CryptoKeyPair, CryptoKeyUsage, errorFromDOMException)
import Data.ArrayBuffer.Types (Uint8Array)
import Data.Function.Uncurried (Fn3, runFn3)
import Effect.Aff (Aff)
import Unsafe.Coerce (unsafeCoerce)



foreign import generateKeyImpl :: forall a b. Fn3 a Boolean (Array CryptoKeyUsage) (Promise b)


-- | Generate a symmetric key
-- |
-- | https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/generateKey
generateKey :: SymmetricAlgorithm
            -> Boolean -- ^ Extractable
            -> Array CryptoKeyUsage
            -> Aff CryptoKey
generateKey a e u = toAff' errorFromDOMException (runFn3 generateKeyImpl a e u)

-- | Generate an asymmetric keypair
-- |
-- | https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/generateKey
generateKeyPair :: AsymmetricAlgorithm
                -> Boolean -- ^ Extractable
                -> Array CryptoKeyUsage
                -> Aff CryptoKeyPair
generateKeyPair a e u = toAff' errorFromDOMException (runFn3 generateKeyImpl a e u)


foreign import data SymmetricAlgorithm :: Type
foreign import data AsymmetricAlgorithm :: Type


foreign import exp65537 :: Uint8Array


-- | https://developer.mozilla.org/en-US/docs/Web/API/RsaHashedKeyGenParams
rsa :: RSAAlgorithm
    -> Int -- ^ Modulus length. Should be at least 2048, or 4096 according to some bozo
    -> Uint8Array -- ^ Public exponent. Just use `exp65537`.
    -> HashingFunction
    -> AsymmetricAlgorithm
rsa r l e h = unsafeCoerce {name: r, modulusLength: l, publicExponent: e, hash: h}

-- | https://developer.mozilla.org/en-US/docs/Web/API/EcKeyGenParams
ec :: ECAlgorithm -> ECCurve -> AsymmetricAlgorithm
ec e c = unsafeCoerce {name: e, namedCurve: c}

-- | https://developer.mozilla.org/en-US/docs/Web/API/HmacKeyGenParams
hmac :: HashingFunction -> SymmetricAlgorithm
hmac h = unsafeCoerce {name: "HMAC", hash: h}

-- | https://developer.mozilla.org/en-US/docs/Web/API/AesKeyGenParams
aes :: AESAlgorithm
    -> AESBitLength
    -> SymmetricAlgorithm
aes a l = unsafeCoerce {name: a, length: l}
