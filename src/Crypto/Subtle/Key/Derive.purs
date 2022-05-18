module Crypto.Subtle.Key.Derive
  ( deriveKey
  , deriveBits
  , DeriveAlgorithm, ec, hkdf, pbkdf2
  , DeriveTargetAlgorithm, hmac, aes
  ) where

import Control.Promise (Promise, toAff')
import Crypto.Subtle.Constants.AES (AESAlgorithm, AESBitLength)
import Crypto.Subtle.Constants.EC (ECAlgorithm)
import Crypto.Subtle.Hash (HashingFunction)
import Crypto.Subtle.Key.Types (CryptoKey, CryptoKeyUsage, errorFromDOMException)
import Data.ArrayBuffer.Types (ArrayBuffer)
import Data.Function.Uncurried (Fn3, Fn5, runFn3, runFn5)
import Effect.Aff (Aff)
import Unsafe.Coerce (unsafeCoerce)



foreign import deriveKeyImpl :: Fn5 DeriveAlgorithm CryptoKey DeriveTargetAlgorithm Boolean (Array CryptoKeyUsage) (Promise CryptoKey)
foreign import deriveBitsImpl :: Fn3 DeriveAlgorithm CryptoKey Int (Promise ArrayBuffer)


-- | https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/deriveKey
deriveKey :: DeriveAlgorithm
          -> CryptoKey -- ^ Base key
          -> DeriveTargetAlgorithm
          -> Boolean -- ^ Extractable
          -> Array CryptoKeyUsage
          -> Aff CryptoKey
deriveKey a k t e u = toAff' errorFromDOMException (runFn5 deriveKeyImpl a k t e u)

-- | https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/deriveBits
deriveBits :: DeriveAlgorithm
           -> CryptoKey -- ^ Base key
           -> Int -- ^ Length in bits
           -> Aff ArrayBuffer
deriveBits a k l = toAff' errorFromDOMException (runFn3 deriveBitsImpl a k l)


foreign import data DeriveAlgorithm :: Type
foreign import data DeriveTargetAlgorithm :: Type


-- | https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/deriveKey#ecdh
ec :: ECAlgorithm
   -> CryptoKey -- ^ Public key of the other entity
   -> DeriveAlgorithm
ec e k = unsafeCoerce {name: e, public: k}

-- | https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/deriveKey#hkdf
hkdf :: HashingFunction
     -> ArrayBuffer -- ^ Salt
     -> ArrayBuffer -- ^ Info
     -> DeriveAlgorithm
hkdf h s i = unsafeCoerce {name: "HKDF", hash: h, salt: s, info: i}

-- | https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/deriveKey#pbkdf2
pbkdf2 :: HashingFunction
       -> ArrayBuffer -- ^ Salt
       -> Int -- ^ Iterations
       -> DeriveAlgorithm
pbkdf2 h s i = unsafeCoerce {name: "PBKDF2", hash: h, salt: s, iterations: i}




-- | https://developer.mozilla.org/en-US/docs/Web/API/HmacKeyGenParams
hmac :: HashingFunction -> DeriveTargetAlgorithm
hmac h = unsafeCoerce {name: "HMAC", hash: h}

-- | https://developer.mozilla.org/en-US/docs/Web/API/AesKeyGenParams
aes :: AESAlgorithm -> AESBitLength -> DeriveTargetAlgorithm
aes a l = unsafeCoerce {name: a, length: l}
