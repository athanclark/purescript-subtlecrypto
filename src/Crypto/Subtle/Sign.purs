module Crypto.Subtle.Sign
  ( sign, verify
  , SignAlgorithm, rsaPKCS1, rsaPSS, ecdsa, hmac
  ) where

import Control.Promise (Promise, toAff')
import Crypto.Subtle.Hash (HashingFunction)
import Crypto.Subtle.Key.Types (CryptoKey, errorFromDOMException)
import Data.ArrayBuffer.Types (ArrayBuffer)
import Data.Function.Uncurried (Fn3, Fn4, runFn3, runFn4)
import Effect.Aff (Aff)
import Unsafe.Coerce (unsafeCoerce)



foreign import data SignAlgorithm :: Type

rsaPKCS1 :: SignAlgorithm
rsaPKCS1 = unsafeCoerce {name: "RSASSA-PKCS1-v1_5"}

-- | https://developer.mozilla.org/en-US/docs/Web/API/RsaPssParams
rsaPSS :: Int -- ^ Salt length
       -> SignAlgorithm
rsaPSS l = unsafeCoerce {name: "RSA-PSS", saltLength: l}

-- | https://developer.mozilla.org/en-US/docs/Web/API/EcdsaParams
ecdsa :: HashingFunction
      -> SignAlgorithm
ecdsa h = unsafeCoerce {name: "ECDSA", hash: h}

hmac :: SignAlgorithm
hmac = unsafeCoerce {name: "HMAC"}


foreign import signImpl :: Fn3 SignAlgorithm CryptoKey ArrayBuffer (Promise ArrayBuffer)

-- | https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/sign
sign :: SignAlgorithm
     -> CryptoKey
     -> ArrayBuffer
     -> Aff ArrayBuffer
sign a k x = toAff' errorFromDOMException (runFn3 signImpl a k x)


foreign import verifyImpl :: Fn4 SignAlgorithm CryptoKey ArrayBuffer ArrayBuffer (Promise Boolean)

-- | https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/verify
verify :: SignAlgorithm
       -> CryptoKey
       -> ArrayBuffer -- ^ Signature
       -> ArrayBuffer -- ^ Subject data
       -> Aff Boolean
verify a k s x = toAff' errorFromDOMException (runFn4 verifyImpl a k s x)
