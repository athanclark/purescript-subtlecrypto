module Crypto.Subtle.Encrypt
  ( encrypt, decrypt
  , EncryptAlgorithm, rsaOAEP, aesCTR, aesCBC, aesGCM, aesKW
  ) where

import Crypto.Subtle.Key.Types (CryptoKey)
import Crypto.Subtle.AES (AESTagLength)

import Prelude ((<<<), (<$))
import Data.Function.Uncurried (Fn3, runFn3)
import Data.Tuple (Tuple (..))
import Data.Maybe (Maybe (..))
import Data.Either (Either (..))
import Data.ArrayBuffer.Types (ArrayBuffer)
import Effect.Promise (Promise, runPromise)
import Effect.Aff (Aff, makeAff, nonCanceler)
import Unsafe.Coerce (unsafeCoerce)



foreign import data EncryptAlgorithm :: Type

rsaOAEP :: Maybe ArrayBuffer -- ^ Label
        -> EncryptAlgorithm
rsaOAEP mL = case mL of
  Nothing -> unsafeCoerce {name: "RSA_OAEP"}
  Just l -> unsafeCoerce {name: "RSA_OAEP", label: l}

aesCTR :: ArrayBuffer -- ^ Counter
       -> Int -- ^ Counter length
       -> EncryptAlgorithm
aesCTR c l = unsafeCoerce {name: "AES-CTR", counter: c, length: l}

aesCBC :: ArrayBuffer -- ^ Initialization vector
       -> EncryptAlgorithm
aesCBC i = unsafeCoerce {name: "AES-CBC", iv: i}

aesGCM :: ArrayBuffer -- ^ Initialization vector
       -> Maybe ArrayBuffer -- ^ Additional data
       -> Maybe AESTagLength -- ^ Tag length
       -> EncryptAlgorithm
aesGCM i mD mT = case Tuple mD mT of
  Tuple Nothing Nothing -> unsafeCoerce {name: "AES-GCM", iv: i}
  Tuple (Just d) (Just t) -> unsafeCoerce {name: "AES-GCM", iv: i, additionalData: d, tagLength: t}
  Tuple (Just d) Nothing -> unsafeCoerce {name: "AES-GCM", iv: i, additionalData: d}
  Tuple Nothing (Just t) -> unsafeCoerce {name: "AES-GCM", iv: i, tagLength: t}

aesKW :: EncryptAlgorithm
aesKW = unsafeCoerce {name: "AES-KW"}




foreign import encryptImpl :: Fn3 EncryptAlgorithm CryptoKey ArrayBuffer (Promise ArrayBuffer)

encrypt :: EncryptAlgorithm
        -> CryptoKey
        -> ArrayBuffer
        -> Aff ArrayBuffer
encrypt a k x = makeAff \resolve ->
  nonCanceler <$ runPromise (resolve <<< Right) (resolve <<< Left) (runFn3 encryptImpl a k x)



foreign import decryptImpl :: Fn3 EncryptAlgorithm CryptoKey ArrayBuffer (Promise ArrayBuffer)

decrypt :: EncryptAlgorithm
        -> CryptoKey
        -> ArrayBuffer
        -> Aff (Maybe ArrayBuffer)
decrypt a k x = makeAff \resolve ->
  nonCanceler <$ runPromise (resolve <<< Right <<< Just) (\_ -> resolve (Right Nothing)) (runFn3 decryptImpl a k x)
