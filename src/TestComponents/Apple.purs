module TestComponents.Apple where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Time.Duration (Milliseconds(..))
import Graphic.Glapple.Data.Event (Event(..), KeyState(..))
import Graphic.Glapple.GlappleM (getGameState, getTotalTime)
import Graphics.Glapple.Data.GameSpec (mkHandlerM, mkInitGameStateM)
import Graphics.Glapple.Data.GameSpecM (GameSpecM(..))
import Graphics.Glapple.Data.Picture (rotate, scale, sprite, translate)
import Math (pi)
import TestComponents.Sprites (Sprite(..))

data Input = StartRotate
type GameState = { rotating :: Boolean }

gameSpec
  :: forall o
   . GameSpecM Sprite GameState Input o
gameSpec = GameSpecM
  { eventHandler
  , inputHandler
  , render
  , initGameState: mkInitGameStateM { rotating: false }
  }
  where
  eventHandler = mkHandlerM case _ of
    KeyEvent "w" KeyDown -> \{ rotating } -> { rotating: not rotating }
    _ -> identity
  inputHandler = mkHandlerM case _ of
    StartRotate -> \_ -> { rotating: true }
  render = do
    timeMaybe <- getTotalTime
    maybeState <- getGameState
    let
      time = case timeMaybe of
        Just (Milliseconds x) -> x
        Nothing -> 0.0
      revolution = case maybeState of
        Just { rotating: true } -> rotate (2.0 * pi * time / 400.0)
        _ -> identity
    pure $ sprite Apple
      # translate (-16.0) (-16.0)
      # scale 5.0 5.0
      # rotate (2.0 * pi * time / 200.0)
      # translate 80.0 80.0
      # revolution