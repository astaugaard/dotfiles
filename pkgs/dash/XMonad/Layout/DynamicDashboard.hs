{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module XMonad.Layout.DynamicDashboard (dashLayout) where

import XMonad
import XMonad.Layout.SelectiveLayout
import XMonad.Layout.LayoutModifier
import qualified XMonad.StackSet as W

data DashLayout sl a = DashLayout (sl a) deriving (Show, Read, Typeable)

dashLayout :: sl a -> l a -> ModifiedLayout (DashLayout sl) l a
dashLayout s = ModifiedLayout $ DashLayout s

instance (SelectiveLayoutClass sl a, Show a, Read a) => LayoutModifier (DashLayout sl) a where
  modifyLayoutWithUpdate (DashLayout ul) (W.Workspace a ll ms) rect = do
    (rects, newTop, newStack) <- runSelLayout ul a ms rect
    (rectsBot, newBot) <- runLayout (W.Workspace a ll newStack) rect
    return ((rects ++ rectsBot, newBot), DashLayout <$> newTop)
