module Test.Main where

import Crypto.Subtle.Key.Types (allUsages, CryptoKeyPair (..), exportKey, raw)
import Crypto.Subtle.Key.Generate (generateKey, generateKeyPair, aes, hmac, ec, rsa, exp65537)
import Crypto.Subtle.Constants.AES as AES
import Crypto.Subtle.Constants.RSA as RSA
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
              do  k <- exportKey raw =<< generateKey (aes mode AES.l128) true allUsages
                  log' "  - 128"
                  log' (unsafeCoerce k)
              do  k <- exportKey raw =<< generateKey (aes mode AES.l192) true allUsages
                  log' "  - 192"
                  log' (unsafeCoerce k)
              do  k <- exportKey raw =<< generateKey (aes mode AES.l256) true allUsages
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
        do  k <- exportKey raw =<< generateKey (hmac Hash.sha1) true allUsages
            log' "  - SHA-1"
            log' (unsafeCoerce k)
        do  k <- exportKey raw =<< generateKey (hmac Hash.sha256) true allUsages
            log' "  - SHA-256"
            log' (unsafeCoerce k)
        do  k <- exportKey raw =<< generateKey (hmac Hash.sha384) true allUsages
            log' "  - SHA-384"
            log' (unsafeCoerce k)
        do  k <- exportKey raw =<< generateKey (hmac Hash.sha512) true allUsages
            log' "  - SHA-512"
            log' (unsafeCoerce k)
    do  let genEC alg = do
              do  CryptoKeyPair {privateKey,publicKey} <- generateKeyPair (ec alg EC.p256) true allUsages
                  log' "  - P-256"
                  log' "    - privateKey"
                  log' (unsafeCoerce privateKey)
                  log' "    - publicKey"
                  publicKey' <- exportKey raw publicKey
                  log' (unsafeCoerce publicKey')
              do  CryptoKeyPair {privateKey,publicKey} <- generateKeyPair (ec alg EC.p384) true allUsages
                  log' "  - P-384"
                  log' "    - privateKey"
                  log' (unsafeCoerce privateKey)
                  log' "    - publicKey"
                  publicKey' <- exportKey raw publicKey
                  log' (unsafeCoerce publicKey')
              do  CryptoKeyPair {privateKey,publicKey} <- generateKeyPair (ec alg EC.p521) true allUsages
                  log' "  - P-521"
                  log' "    - privateKey"
                  log' (unsafeCoerce privateKey)
                  log' "    - publicKey"
                  publicKey' <- exportKey raw publicKey
                  log' (unsafeCoerce publicKey')
        log' "- ECDSA"
        genEC EC.ecdsa
        log' "- ECDH"
        genEC EC.ecdh
    do  let genRSA alg = do
              do  CryptoKeyPair {privateKey,publicKey} <- generateKeyPair (rsa alg 2048 exp65537 Hash.sha1) true allUsages
                  log' "  - SHA-1"
                  log' "    - privateKey"
                  log' (unsafeCoerce privateKey)
                  log' "    - publicKey"
                  log' (unsafeCoerce publicKey)
              do  CryptoKeyPair {privateKey,publicKey} <- generateKeyPair (rsa alg 2048 exp65537 Hash.sha256) true allUsages
                  log' "  - SHA-256"
                  log' "    - privateKey"
                  log' (unsafeCoerce privateKey)
                  log' "    - publicKey"
                  log' (unsafeCoerce publicKey)
              do  CryptoKeyPair {privateKey,publicKey} <- generateKeyPair (rsa alg 2048 exp65537 Hash.sha384) true allUsages
                  log' "  - SHA-384"
                  log' "    - privateKey"
                  log' (unsafeCoerce privateKey)
                  log' "    - publicKey"
                  log' (unsafeCoerce publicKey)
              do  CryptoKeyPair {privateKey,publicKey} <- generateKeyPair (rsa alg 2048 exp65537 Hash.sha512) true allUsages
                  log' "  - SHA-512"
                  log' "    - privateKey"
                  log' (unsafeCoerce privateKey)
                  log' "    - publicKey"
                  log' (unsafeCoerce publicKey)
        log' "- RSASSA-PKCS1-v1_5"
        genRSA RSA.rsaPKCS1
        log' "- RSA-PSS"
        genRSA RSA.rsaPSS
        log' "- RSA-OAEP"
        genRSA RSA.rsaOAEP


log' :: String -> Aff Unit
log' = liftEffect <<< log
