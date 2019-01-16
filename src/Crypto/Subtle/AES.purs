module Crypto.Subtle.AES
  ( AESAlgorithm, aesCTR, aesCBC, aesGCM, aesKW
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
