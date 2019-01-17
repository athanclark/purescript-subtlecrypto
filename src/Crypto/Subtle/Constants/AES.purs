module Crypto.Subtle.Constants.AES
  ( AESAlgorithm, aesCTR, aesCBC, aesGCM, aesKW
  , AESBitLength, l128, l192, l256
  , AESTagLength, t32, t64, t96, t104, t112, t120, t128
  ) where

import Prelude (class Eq)


newtype AESAlgorithm = AESAlgorithm String

derive newtype instance eqAESAlgorithm :: Eq AESAlgorithm

aesCTR :: AESAlgorithm
aesCTR = AESAlgorithm "AES-CTR"
aesCBC :: AESAlgorithm
aesCBC = AESAlgorithm "AES-CBC"
aesGCM :: AESAlgorithm
aesGCM = AESAlgorithm "AES-GCM"
aesKW :: AESAlgorithm
aesKW  = AESAlgorithm "AES-KW"



newtype AESBitLength = AESBitLength Int

derive newtype instance eqAESBitLength :: Eq AESBitLength

l128 :: AESBitLength
l128 = AESBitLength 128
l192 :: AESBitLength
l192 = AESBitLength 192
l256 :: AESBitLength
l256 = AESBitLength 256



newtype AESTagLength = AESTagLength Int

derive newtype instance eqAESTagLength :: Eq AESTagLength

t32 :: AESTagLength
t32 = AESTagLength 32
t64 :: AESTagLength
t64 = AESTagLength 64
t96 :: AESTagLength
t96 = AESTagLength 96
t104 :: AESTagLength
t104 = AESTagLength 104
t112 :: AESTagLength
t112 = AESTagLength 112
t120 :: AESTagLength
t120 = AESTagLength 120
t128 :: AESTagLength
t128 = AESTagLength 128
