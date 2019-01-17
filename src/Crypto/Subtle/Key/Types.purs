module Crypto.Subtle.Key.Types
  ( CryptoKeyType
  , secret, public, private
  , CryptoKeyUsage
  , encrypt, decrypt, sign, verify, deriveKey, deriveBits, unwrapKey, wrapKey
  , allUsages
  , CryptoKey
  , getType, getExtractable, getAlgorithm, getUsages
  , exportKey
  , CryptoKeyPair (..)
  , ExternalFormat, raw, pkcs8, spki, jwk
  ) where


import Prelude ((<<<), (<$), class Eq)
import Data.Either (Either (..))
import Data.Function.Uncurried (Fn2, runFn2)
import Data.ArrayBuffer.Types (ArrayBuffer)
import Foreign (Foreign)
import Effect.Aff (Aff, makeAff, nonCanceler)
import Effect.Promise (Promise, runPromise)
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

exportKey :: ExternalFormat
          -> CryptoKey
          -> Aff ArrayBuffer
exportKey f x = makeAff \resolve ->
  nonCanceler <$ runPromise (resolve <<< Right) (resolve <<< Left) (runFn2 exportKeyImpl f x)
