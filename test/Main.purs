module Test.Main where

import Crypto.Subtle.Key.Types (allUsages)
import Crypto.Subtle.Key.Generate (generateKey, aes, hmac, ec, rsa)
import Crypto.Subtle.Constants.AES as AES
import Crypto.Subtle.Constants.EC as EC
import Crypto.Subtle.Hash as Hash

import Prelude
import Data.Either (Either (..))
import Effect (Effect)
import Effect.Exception (throwException)
import Effect.Class (liftEffect)
import Effect.Aff (Aff, runAff_)
import Effect.Console (log)
import Unsafe.Coerce (unsafeCoerce)




main :: Effect Unit
main = do
  let resolve eX = case eX of
        Left e -> throwException e
        Right _ -> pure unit
  runAff_ resolve do
    log' "Generating Keys..."
    do  let genAES mode = do
              do  k <- generateKey (aes mode AES.l128) true allUsages
                  log' "  - 128"
                  log' (unsafeCoerce k)
              do  k <- generateKey (aes mode AES.l192) true allUsages
                  log' "  - 192"
                  log' (unsafeCoerce k)
              do  k <- generateKey (aes mode AES.l256) true allUsages
                  log' "  - 256"
                  log' (unsafeCoerce k)
        log' "- AES-CTR"
        genAES AES.aesCTR
        log' "- AES-CBC"
        genAES AES.aesCBC
        log' "- AES-GCM"
        genAES AES.aesGCM
        log' "- AES-KW"
        genAES AES.aesKW
    do  log' "HMAC"
        do  k <- generateKey (hmac Hash.sha1) true allUsages
            log' "  - SHA-1"
            log' (unsafeCoerce k)
        do  k <- generateKey (hmac Hash.sha256) true allUsages
            log' "  - SHA-256"
            log' (unsafeCoerce k)
        do  k <- generateKey (hmac Hash.sha384) true allUsages
            log' "  - SHA-384"
            log' (unsafeCoerce k)
        do  k <- generateKey (hmac Hash.sha512) true allUsages
            log' "  - SHA-512"
            log' (unsafeCoerce k)
    do  let genEC alg = do
              do  k <- generateKey (ec alg EC.p256) true allUsages
                  log' "  - P-256"
                  log' (unsafeCoerce k)
              do  k <- generateKey (ec alg EC.p384) true allUsages
                  log' "  - P-384"
                  log' (unsafeCoerce k)
              do  k <- generateKey (ec alg EC.p521) true allUsages
                  log' "  - P-521"
                  log' (unsafeCoerce k)
        log' "- ECDSA"
        genEC EC.ecdsa
        log' "- ECDH"
        genEC EC.ecdh


log' :: String -> Aff Unit
log' = liftEffect <<< log
