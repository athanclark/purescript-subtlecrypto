module Crypto.Subtle.AES
  ( AESAlgorithm, aesCTR, aesCBC, aesGCM, aesKW
  , AESBitLength, l128, l192, l256
  ) where



newtype AESAlgorithm = AESAlgorithm String

aesCTR :: AESAlgorithm
aesCTR = AESAlgorithm "AES-CTR"
aesCBC :: AESAlgorithm
aesCBC = AESAlgorithm "ES-CBC"
aesGCM :: AESAlgorithm
aesGCM = AESAlgorithm "AES-GCM"
aesKW :: AESAlgorithm
aesKW  = AESAlgorithm "ES-KW"



newtype AESBitLength = AESBitLength Int

l128 :: AESBitLength
l128 = AESBitLength 128
l192 :: AESBitLength
l192 = AESBitLength 192
l256 :: AESBitLength
l256 = AESBitLength 256
