module Crypto.Subtle.Key.Types
  ( CryptoKeyType
  , CryptoKeyUsage
  , encrypt, decrypt, sign, verify, deriveKey, deriveBits, unwrapKey, wrapKey
  , CryptoKey
  , getType, getExtractable, getAlgorithm, getUsages
  , exportKey
  , ExternalFormat, raw, pkcs8, spki, jwk
  ) where


import Prelude ((<<<), (<$))
import Data.Either (Either (..))
import Data.Function.Uncurried (Fn2, runFn2)
import Data.ArrayBuffer.Types (ArrayBuffer)
import Foreign (Foreign)
import Effect.Aff (Aff, makeAff, nonCanceler)
import Effect.Promise (Promise, runPromise)


-- TODO enumerate different key types - public, secret, etc.
newtype CryptoKeyType = CryptoKeyType String

newtype CryptoKeyUsage = CryptoKeyUsage String


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




newtype CryptoKey = CryptoKey
  { "type" :: CryptoKeyType
  , extractable :: Boolean
  , algorithm :: Foreign
  , usages :: Array CryptoKeyUsage
  }


getType :: CryptoKey -> CryptoKeyType
getType (CryptoKey r) = r."type"

getExtractable :: CryptoKey -> Boolean
getExtractable (CryptoKey r) = r.extractable

getAlgorithm :: CryptoKey -> Foreign
getAlgorithm (CryptoKey r) = r.algorithm

getUsages :: CryptoKey -> Array CryptoKeyUsage
getUsages (CryptoKey r) = r.usages



newtype ExternalFormat = ExternalFormat String

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
