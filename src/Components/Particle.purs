module Components.Particle where

import Prelude

import Control.Safely (replicateM_)
import Effect.Class (liftEffect)
import Effect.Random (randomRange)
import Graphics.Glapple.Data.Complex (complex, rotateComplex, (:*))
import Graphics.Glapple.Data.Component (Component(..))
import Graphics.Glapple.Data.Picture (opacity, scale)
import Graphics.Glapple.Hooks.UseDestroy (useDestroy, useDestroyNow)
import Graphics.Glapple.Hooks.UseLocalTime (useLocalTime)
import Graphics.Glapple.Hooks.UseRenderer (useRenderer)
import Graphics.Glapple.Hooks.UseRunner (useChildRunnerNow)
import Graphics.Glapple.Hooks.UseTimeout (useTimeout)
import Graphics.Glapple.Hooks.UseTransform (useRotateNow)
import Graphics.Glapple.Hooks.UseVelocity (useVelocityNow)
import Math (pi)
import Sprites (apple)

particle
  :: Component { lifeTime :: Number } Unit Unit
particle = Component \{ lifeTime } -> do
  let
    particleChild = Component \_ -> do
      getTime <- useLocalTime
      destroy <- useDestroy

      randomVelocity <- liftEffect $ randomRange 20.0 60.0
      randomRot2 <- liftEffect $ randomRange 0.0 $ 2.0 * pi -- 速度用
      useVelocityNow $ randomVelocity :* rotateComplex randomRot2

      randomRot <- liftEffect $ randomRange 0.0 $ 2.0 * pi
      useRotateNow randomRot

      useRenderer 0.0 $ do
        time <- getTime
        pure $ apple
          # scale (complex 0.2 0.2)
          # opacity (1.0 - time / lifeTime)

      useTimeout lifeTime destroy

  replicateM_ 10 $ useChildRunnerNow particleChild unit

  useDestroyNow
