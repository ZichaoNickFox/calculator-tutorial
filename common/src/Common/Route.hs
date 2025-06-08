{-# LANGUAGE EmptyCase #-}
{-# LANGUAGE DeriveLift #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE EmptyCase #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE PackageImports #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE UndecidableInstances #-}

module Common.Route where

{- -- You will probably want these imports for composing Encoders.
import Prelude hiding (id, (.))
import Control.Category
-}

import Data.Text (Text)
import Data.Functor.Identity
import "template-haskell" Language.Haskell.TH.Syntax

import Obelisk.Route
import Obelisk.Route.TH

data BackendRoute :: * -> * where
  -- | Used to handle unparseable routes.
  BackendRoute_Missing :: BackendRoute ()
  -- You can define any routes that will be handled specially by the backend here.
  -- i.e. These do not serve the frontend, but do something different, such as serving static files.

data TutorialRoute :: * -> * where
  TutorialRoute_1 :: TutorialRoute ()
  TutorialRoute_2 :: TutorialRoute ()
  TutorialRoute_3 :: TutorialRoute ()
  TutorialRoute_4 :: TutorialRoute ()
  TutorialRoute_5 :: TutorialRoute ()
  TutorialRoute_6 :: TutorialRoute ()
  TutorialRoute_7 :: TutorialRoute ()
  TutorialRoute_8 :: TutorialRoute ()
  TutorialRoute_9 :: TutorialRoute ()
  TutorialRoute_10 :: TutorialRoute ()
  TutorialRoute_11 :: TutorialRoute ()

deriving instance Lift (TutorialRoute ())

data FrontendRoute :: * -> * where
  FrontendRoute_Main :: FrontendRoute ()
  FrontendRoute_Tutorial :: FrontendRoute (R TutorialRoute)
  -- This type is used to define frontend routes, i.e. ones for which the backend will serve the frontend.

fullRouteEncoder
  :: Encoder (Either Text) Identity (R (FullRoute BackendRoute FrontendRoute)) PageName
fullRouteEncoder = mkFullRouteEncoder
  (FullRoute_Backend BackendRoute_Missing :/ ())
  (\case
      BackendRoute_Missing -> PathSegment "missing" $ unitEncoder mempty)
  (\case
      FrontendRoute_Main -> PathEnd $ unitEncoder mempty
      FrontendRoute_Tutorial -> PathSegment "tutorial" $ pathComponentEncoder $ \case
        TutorialRoute_1 -> PathSegment "1" $ unitEncoder mempty
        TutorialRoute_2 -> PathSegment "2" $ unitEncoder mempty
        TutorialRoute_3 -> PathSegment "3" $ unitEncoder mempty
        TutorialRoute_4 -> PathSegment "4" $ unitEncoder mempty
        TutorialRoute_5 -> PathSegment "5" $ unitEncoder mempty
        TutorialRoute_6 -> PathSegment "6" $ unitEncoder mempty
        TutorialRoute_7 -> PathSegment "7" $ unitEncoder mempty
        TutorialRoute_8 -> PathSegment "8" $ unitEncoder mempty
        TutorialRoute_9 -> PathSegment "9" $ unitEncoder mempty
        TutorialRoute_10 -> PathSegment "10" $ unitEncoder mempty
        TutorialRoute_11 -> PathSegment "11" $ unitEncoder mempty
  )

concat <$> mapM deriveRouteComponent
  [ ''BackendRoute
  , ''FrontendRoute
  , ''TutorialRoute
  ]
