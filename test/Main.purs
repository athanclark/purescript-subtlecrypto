module Test.Main where

import Prelude

import Crypto.Random (getRandomValues, randomUUID)
import Crypto.Subtle.Constants.AES as AES
import Crypto.Subtle.Constants.EC as EC
import Crypto.Subtle.Constants.RSA as RSA
import Crypto.Subtle.Hash as Hash
import Crypto.Subtle.Key.Generate (generateKey, generateKeyPair, aes, hmac, ec, rsa, exp65537)
import Crypto.Subtle.Key.Import (hkdf, importKey, pbkdf2)
import Crypto.Subtle.Key.Types (CryptoKeyPair(..), decrypt, deriveBits, deriveKey, encrypt, exportKey, raw, sign, unwrapKey, verify, wrapKey)
import Data.ArrayBuffer.Typed (buffer, empty)
import Data.ArrayBuffer.Types (Uint8Array)
import Data.Either (Either(..))
import Effect (Effect)
import Effect.Aff (Aff, runAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Exception (throwException)
import Unsafe.Coerce (unsafeCoerce)
import Web.Encoding.TextEncoder (new, encode)

main :: Effect Unit
main = do
  let
    resolve eX = case eX of
      Left e -> throwException e
      Right _ -> pure unit
  runAff_ resolve do
    log' "Generating Keys..."
    do
      let
        genAES mode usages = do
          do
            log' "  - 128"
            k <- exportKey raw =<< generateKey (aes mode AES.l128) true usages
            log' (unsafeCoerce k)
          -- As of 2023 these will work in Firefox only
          do
            log' "  - 192"
            k <- exportKey raw =<< generateKey (aes mode AES.l192) true usages
            log' (unsafeCoerce k)
          do
            log' "  - 256"
            k <- exportKey raw =<< generateKey (aes mode AES.l256) true usages
            log' (unsafeCoerce k)
      log' "- AES-CTR"
      genAES AES.aesCTR [ encrypt, decrypt, wrapKey, unwrapKey ]
      log' "- AES-CBC"
      genAES AES.aesCBC [ encrypt, decrypt, wrapKey, unwrapKey ]
      log' "- AES-GCM"
      genAES AES.aesGCM [ encrypt, decrypt, wrapKey, unwrapKey ]
      log' "- AES-KW"
      genAES AES.aesKW [ wrapKey, unwrapKey ]
    do
      log' "HMAC"
      let usages = [ sign, verify ]
      do
        k <- exportKey raw =<< generateKey (hmac Hash.sha1) true usages
        log' "  - SHA-1"
        log' (unsafeCoerce k)
      do
        k <- exportKey raw =<< generateKey (hmac Hash.sha256) true usages
        log' "  - SHA-256"
        log' (unsafeCoerce k)
      do
        k <- exportKey raw =<< generateKey (hmac Hash.sha384) true usages
        log' "  - SHA-384"
        log' (unsafeCoerce k)
      do
        k <- exportKey raw =<< generateKey (hmac Hash.sha512) true usages
        log' "  - SHA-512"
        log' (unsafeCoerce k)
    do
      let
        genEC alg usages = do
          do
            log' "  - P-256"
            CryptoKeyPair { privateKey, publicKey } <- generateKeyPair (ec alg EC.p256) true usages
            log' "    - privateKey"
            log' (unsafeCoerce privateKey)
            log' "    - publicKey"
            publicKey' <- exportKey raw publicKey
            log' (unsafeCoerce publicKey')
          do
            log' "  - P-384"
            CryptoKeyPair { privateKey, publicKey } <- generateKeyPair (ec alg EC.p384) true usages
            log' "    - privateKey"
            log' (unsafeCoerce privateKey)
            log' "    - publicKey"
            publicKey' <- exportKey raw publicKey
            log' (unsafeCoerce publicKey')
          do
            log' "  - P-521"
            CryptoKeyPair { privateKey, publicKey } <- generateKeyPair (ec alg EC.p521) true usages
            log' "    - privateKey"
            log' (unsafeCoerce privateKey)
            log' "    - publicKey"
            publicKey' <- exportKey raw publicKey
            log' (unsafeCoerce publicKey')
      log' "- ECDSA"
      genEC EC.ecdsa [ sign, verify ]
      log' "- ECDH"
      genEC EC.ecdh [ deriveKey ]
    do
      let
        genRSA alg usages = do
          do
            log' "  - SHA-1"
            CryptoKeyPair { privateKey, publicKey } <- generateKeyPair (rsa alg 2048 exp65537 Hash.sha1) true usages
            log' "    - privateKey"
            log' (unsafeCoerce privateKey)
            log' "    - publicKey"
            log' (unsafeCoerce publicKey)
          do
            log' "  - SHA-256"
            CryptoKeyPair { privateKey, publicKey } <- generateKeyPair (rsa alg 2048 exp65537 Hash.sha256) true usages
            log' "    - privateKey"
            log' (unsafeCoerce privateKey)
            log' "    - publicKey"
            log' (unsafeCoerce publicKey)
          do
            log' "  - SHA-384"
            CryptoKeyPair { privateKey, publicKey } <- generateKeyPair (rsa alg 2048 exp65537 Hash.sha384) true usages
            log' "    - privateKey"
            log' (unsafeCoerce privateKey)
            log' "    - publicKey"
            log' (unsafeCoerce publicKey)
          do
            log' "  - SHA-512"
            CryptoKeyPair { privateKey, publicKey } <- generateKeyPair (rsa alg 2048 exp65537 Hash.sha512) true usages
            log' "    - privateKey"
            log' (unsafeCoerce privateKey)
            log' "    - publicKey"
            log' (unsafeCoerce publicKey)
      log' "- RSASSA-PKCS1-v1_5"
      genRSA RSA.rsaPKCS1 [ sign, verify ]
      log' "- RSA-PSS"
      genRSA RSA.rsaPSS [ sign, verify ]
      log' "- RSA-OAEP"
      genRSA RSA.rsaOAEP [ encrypt, decrypt ]
    do
      log' "KDF"
      do
        enc <- liftEffect new
        let sk = encode "a special key" enc
        let
          importTest txt importType =
            do
              log' ("  - extractable " <> txt)
              kexp <- importKey raw (buffer sk) importType true [ deriveBits ]
              log' (unsafeCoerce kexp)
              log' ("  - " <> txt)
              k <- importKey raw (buffer sk) importType false [ deriveBits ]
              log' (unsafeCoerce k)

        importTest "PBKDF2" pbkdf2
        importTest "HKDF" hkdf
    do
      log' "Random"
      do
        log' "  - UUID"
        ruuid <- liftEffect randomUUID
        log' ruuid
      do
        log' "  - Random Values"
        em <- liftEffect (empty 30) :: Aff Uint8Array
        rand <- liftEffect (getRandomValues em)
        log' (unsafeCoerce rand)

log' :: String -> Aff Unit
log' = liftEffect <<< log
