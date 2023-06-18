module Crypto.Subtle.Key.Wrap
  where

import Control.Promise (Promise, toAff')
import Crypto.Subtle.Encrypt (EncryptAlgorithm)
import Crypto.Subtle.Key.Import (ImportAlgorithm)
import Crypto.Subtle.Key.Types (CryptoKey, CryptoKeyUsage, ExternalFormat, errorFromDOMException)
import Data.ArrayBuffer.Types (ArrayBuffer)
import Data.Function.Uncurried (Fn4, Fn7, runFn4, runFn7)
import Effect.Aff (Aff)



foreign import wrapKeyImpl :: Fn4 ExternalFormat CryptoKey CryptoKey EncryptAlgorithm (Promise ArrayBuffer)

-- | https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/wrapKey
wrapKey :: ExternalFormat
        -> CryptoKey -- ^ Subject key
        -> CryptoKey -- ^ Wrapping key
        -> EncryptAlgorithm
        -> Aff ArrayBuffer
wrapKey f x k a = toAff' errorFromDOMException (runFn4 wrapKeyImpl f x k a)


foreign import unwrapKeyImpl :: Fn7 ExternalFormat ArrayBuffer CryptoKey EncryptAlgorithm ImportAlgorithm Boolean (Array CryptoKeyUsage) (Promise CryptoKey)

-- | https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/unwrapKey
unwrapKey :: ExternalFormat
          -> ArrayBuffer -- ^ Wrapped key
          -> CryptoKey -- ^ Unwrapping key
          -> EncryptAlgorithm
          -> ImportAlgorithm
          -> Boolean -- ^ Extractable
          -> Array CryptoKeyUsage
          -- -> Aff (Maybe CryptoKey)
          -> Aff CryptoKey
unwrapKey f x k a i e u = toAff' errorFromDOMException (runFn7 unwrapKeyImpl f x k a i e u)
