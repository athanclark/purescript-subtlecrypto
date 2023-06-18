module Crypto.Random
  ( getRandomValues
  , randomUUID
  )
  where


import Data.ArrayBuffer.Typed (class TypedArray)
import Data.ArrayBuffer.Types (ArrayView)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)

foreign import getRandomValuesImpl :: forall a . EffectFn1 (ArrayView a) (ArrayView a)

foreign import randomUUID :: Effect String

getRandomValues :: forall a t. TypedArray a t => ArrayView a -> Effect (ArrayView a)
getRandomValues ta = runEffectFn1 getRandomValuesImpl ta
