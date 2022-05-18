module Crypto.Subtle.Encrypt
  ( encrypt, decrypt
  , EncryptAlgorithm, rsaOAEP, aesCTR, aesCBC, aesGCM, aesKW
  ) where

import Control.Promise (Promise, toAff')
import Crypto.Subtle.Constants.AES (AESTagLength)
import Crypto.Subtle.Key.Types (CryptoKey, errorFromDOMException)
import Data.ArrayBuffer.Types (ArrayBuffer)
import Data.Function.Uncurried (Fn3, runFn3)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Effect.Aff (Aff)
import Unsafe.Coerce (unsafeCoerce)



foreign import data EncryptAlgorithm :: Type

-- | https://developer.mozilla.org/en-US/docs/Web/API/RsaOaepParams
rsaOAEP :: Maybe ArrayBuffer -- ^ Label
        -> EncryptAlgorithm
rsaOAEP mL = case mL of
  Nothing -> unsafeCoerce {name: "RSA_OAEP"}
  Just l -> unsafeCoerce {name: "RSA_OAEP", label: l}

-- | https://developer.mozilla.org/en-US/docs/Web/API/AesCtrParams
aesCTR :: ArrayBuffer -- ^ Counter
       -> Int -- ^ Counter length
       -> EncryptAlgorithm
aesCTR c l = unsafeCoerce {name: "AES-CTR", counter: c, length: l}

-- | https://developer.mozilla.org/en-US/docs/Web/API/AesCbcParams
aesCBC :: ArrayBuffer -- ^ Initialization vector
       -> EncryptAlgorithm
aesCBC i = unsafeCoerce {name: "AES-CBC", iv: i}

-- | https://developer.mozilla.org/en-US/docs/Web/API/AesGcmParams
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

-- | https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/encrypt
encrypt :: EncryptAlgorithm
        -> CryptoKey
        -> ArrayBuffer
        -> Aff ArrayBuffer
encrypt a k x = toAff' errorFromDOMException (runFn3 encryptImpl a k x)



foreign import decryptImpl :: Fn3 EncryptAlgorithm CryptoKey ArrayBuffer (Promise ArrayBuffer)

-- | https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/decrypt
decrypt :: EncryptAlgorithm
        -> CryptoKey
        -> ArrayBuffer
        -> Aff ArrayBuffer
decrypt a k x = toAff' errorFromDOMException (runFn3 decryptImpl a k x)
