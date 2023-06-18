module Crypto.Subtle.Key.Types
  ( CryptoKey
  , CryptoKeyPair(..)
  , CryptoKeyType
  , CryptoKeyUsage
  , ExternalFormat
  , allUsages
  , decrypt
  , deriveBits
  , deriveKey
  , encrypt
  , errorFromDOMException
  , exportKey
  , getAlgorithm
  , getExtractable
  , getType
  , getUsages
  , jwk
  , pkcs8
  , private
  , public
  , raw
  , secret
  , sign
  , spki
  , unwrapKey
  , verify
  , wrapKey
  )
  where

import Prelude ((>>=), class Eq)
import Control.Monad.Except (runExcept)
import Control.Promise (Promise, toAff')
import Data.ArrayBuffer.Types (ArrayBuffer)
import Data.Either (Either(..))
import Data.Function.Uncurried (Fn2, runFn2)
import Effect.Aff (Aff, Error, error)
import Foreign (Foreign, readString)
import Foreign.Index (readProp)
import Unsafe.Coerce (unsafeCoerce)


-- TODO enumerate different key types - public, secret, etc.
newtype CryptoKeyType = CryptoKeyType String

derive newtype instance eqCryptoKeyType :: Eq CryptoKeyType

secret :: CryptoKeyType
secret = CryptoKeyType "secret"
public :: CryptoKeyType
public = CryptoKeyType "public"
private :: CryptoKeyType
private = CryptoKeyType "private"


newtype CryptoKeyUsage = CryptoKeyUsage String

derive newtype instance eqCryptoKeyUsage :: Eq CryptoKeyUsage


encrypt :: CryptoKeyUsage
encrypt    = CryptoKeyUsage "encrypt"
decrypt :: CryptoKeyUsage
decrypt    = CryptoKeyUsage "decrypt"
sign :: CryptoKeyUsage
sign       = CryptoKeyUsage "sign"
verify :: CryptoKeyUsage
verify     = CryptoKeyUsage "verify"
deriveKey :: CryptoKeyUsage
deriveKey  = CryptoKeyUsage "deriveKey"
deriveBits :: CryptoKeyUsage
deriveBits = CryptoKeyUsage "deriveBits"
wrapKey :: CryptoKeyUsage
wrapKey    = CryptoKeyUsage "wrapKey"
unwrapKey :: CryptoKeyUsage
unwrapKey  = CryptoKeyUsage "unwrapKey"


allUsages :: Array CryptoKeyUsage
allUsages = [encrypt, decrypt, sign, verify, deriveKey, deriveBits, wrapKey, unwrapKey]



foreign import data CryptoKey :: Type


getType :: CryptoKey -> CryptoKeyType
getType r = (unsafeCoerce r)."type"

getExtractable :: CryptoKey -> Boolean
getExtractable r = (unsafeCoerce r).extractable

getAlgorithm :: CryptoKey -> Foreign
getAlgorithm r = (unsafeCoerce r).algorithm

getUsages :: CryptoKey -> Array CryptoKeyUsage
getUsages r = (unsafeCoerce r).usages


newtype CryptoKeyPair = CryptoKeyPair
  { privateKey :: CryptoKey
  , publicKey :: CryptoKey
  }




newtype ExternalFormat = ExternalFormat String

derive newtype instance eqExternalFormat :: Eq ExternalFormat

raw :: ExternalFormat
raw = ExternalFormat "raw"
pkcs8 :: ExternalFormat
pkcs8 = ExternalFormat "pkcs8"
spki :: ExternalFormat
spki = ExternalFormat "spki"
jwk :: ExternalFormat
jwk = ExternalFormat "jwk"


foreign import exportKeyImpl :: Fn2 ExternalFormat CryptoKey (Promise ArrayBuffer)

-- | https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/exportKey
exportKey :: ExternalFormat
          -> CryptoKey
          -> Aff ArrayBuffer
exportKey f x = toAff' errorFromDOMException (runFn2 exportKeyImpl f x)

-- Most of the Promises throw DOMException, so read the message from the DOMException.
-- https://developer.mozilla.org/en-US/docs/Web/API/DOMException
-- Some of the Promises throw TypeError, which also has a message property.
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypeError
errorFromDOMException :: Foreign -> Error
errorFromDOMException x = case runExcept (readProp "message" x >>= readString) of
  Left _ -> error "Not a DOMException"
  Right m -> error m
