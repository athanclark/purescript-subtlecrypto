module Crypto.Subtle.EC
  ( ECAlgorithm, ecdsa, ecdh
  , ECCurve, p256, p384, p521
  ) where



newtype ECAlgorithm = ECAlgorithm String

ecdsa :: ECAlgorithm
ecdsa = ECAlgorithm "ECDSA"
ecdh :: ECAlgorithm
ecdh = ECAlgorithm "ECDH"



newtype ECCurve = ECCurve String

p256 :: ECCurve
p256 = ECCurve "P-256"
p384 :: ECCurve
p384 = ECCurve "P-384"
p521 :: ECCurve
p521 = ECCurve "P-521"
