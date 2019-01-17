module Crypto.Subtle.Constants.RSA
  ( RSAAlgorithm, rsaPKCS1, rsaPSS, rsaOAEP
  ) where

import Prelude (class Eq)

newtype RSAAlgorithm = RSAAlgorithm String

derive newtype instance eqRSAAlgorithm :: Eq RSAAlgorithm

rsaPKCS1 :: RSAAlgorithm
rsaPKCS1 = RSAAlgorithm "RSASSA-PKCS1-v1_5"
rsaPSS :: RSAAlgorithm
rsaPSS = RSAAlgorithm "RSA-PSS"
rsaOAEP :: RSAAlgorithm
rsaOAEP = RSAAlgorithm "RSA-OAEP"
