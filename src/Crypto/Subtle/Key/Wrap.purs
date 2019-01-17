module Crypto.Subtle.Key.Wrap
  where

import Crypto.Subtle.Key.Types (CryptoKey, ExternalFormat, CryptoKeyUsage)
import Crypto.Subtle.Key.Import (ImportAlgorithm)
import Crypto.Subtle.Encrypt (EncryptAlgorithm)

import Prelude ((<<<), (<$))
import Data.Function.Uncurried (Fn4, Fn7, runFn4, runFn7)
import Data.Maybe (Maybe (..))
import Data.Either (Either (..))
import Data.ArrayBuffer.Types (ArrayBuffer)
import Effect.Promise (Promise, runPromise)
import Effect.Aff (Aff, makeAff, nonCanceler)



foreign import wrapKeyImpl :: Fn4 ExternalFormat CryptoKey CryptoKey EncryptAlgorithm (Promise ArrayBuffer)

wrapKey :: ExternalFormat
        -> CryptoKey -- ^ Subject key
        -> CryptoKey -- ^ Wrapping key
        -> EncryptAlgorithm
        -> Aff ArrayBuffer
wrapKey f x k a = makeAff \resolve ->
  nonCanceler <$ runPromise (resolve <<< Right) (resolve <<< Left) (runFn4 wrapKeyImpl f x k a)


foreign import unwrapKeyImpl :: Fn7 ExternalFormat ArrayBuffer CryptoKey EncryptAlgorithm ImportAlgorithm Boolean (Array CryptoKeyUsage) (Promise CryptoKey)

unwrapKey :: ExternalFormat
          -> ArrayBuffer -- ^ Wrapped key
          -> CryptoKey -- ^ Unwrapping key
          -> EncryptAlgorithm
          -> ImportAlgorithm
          -> Boolean -- ^ Extractable
          -> Array CryptoKeyUsage
          -> Aff (Maybe CryptoKey)
unwrapKey f x k a i e u = makeAff \resolve ->
  nonCanceler <$ runPromise (resolve <<< Right <<< Just) (\_ -> resolve (Right Nothing)) (runFn7 unwrapKeyImpl f x k a i e u)
