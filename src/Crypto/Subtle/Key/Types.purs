module Crypto.Subtle.Key.Types
  ( CryptoKeyType
  , CryptoKeyUsage
  , encrypt, decrypt, sign, verify, deriveKey, deriveBits, unwrapKey, wrapKey
  , CryptoKey (..)
  , getType, getExtractable, getAlgorithm, getUsages
  ) where


import Foreign (Foreign)



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
