module Crypto.Subtle.Key.Import
  ( importKey
  , ImportAlgorithm, rsa, ec, hmac, aes
  ) where

import Control.Promise (Promise, toAff')
import Crypto.Subtle.Constants.AES (AESAlgorithm)
import Crypto.Subtle.Constants.EC (ECAlgorithm, ECCurve)
import Crypto.Subtle.Constants.RSA (RSAAlgorithm)
import Crypto.Subtle.Hash (HashingFunction)
import Crypto.Subtle.Key.Types (CryptoKey, CryptoKeyUsage, ExternalFormat, errorFromDOMException)
import Data.ArrayBuffer.Types (ArrayBuffer)
import Data.Function.Uncurried (Fn5, runFn5)
import Effect.Aff (Aff)
import Unsafe.Coerce (unsafeCoerce)



foreign import importKeyImpl :: Fn5 ExternalFormat ArrayBuffer ImportAlgorithm Boolean (Array CryptoKeyUsage) (Promise CryptoKey)


-- | https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/importKey
importKey :: ExternalFormat
          -> ArrayBuffer -- ^ Key data
          -> ImportAlgorithm
          -> Boolean -- ^ Extractable
          -> Array CryptoKeyUsage
          -> Aff CryptoKey
importKey f x a e u = toAff' errorFromDOMException (runFn5 importKeyImpl f x a e u)


foreign import data ImportAlgorithm :: Type


rsa :: RSAAlgorithm -> HashingFunction -> ImportAlgorithm
rsa r h = unsafeCoerce {name: r, hash: h}

ec :: ECAlgorithm -> ECCurve -> ImportAlgorithm
ec e c = unsafeCoerce {name: e, namedCurve: c}

hmac :: HashingFunction -> ImportAlgorithm
hmac h = unsafeCoerce {name: "HMAC", hash: h}

aes :: AESAlgorithm -> ImportAlgorithm
aes a = unsafeCoerce {name: a}
