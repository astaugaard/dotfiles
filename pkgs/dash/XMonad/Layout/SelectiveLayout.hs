{-# LANGUAGE TupleSections #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE FlexibleInstances #-}

module XMonad.Layout.SelectiveLayout (filterStack, grabOne, XPropertyQueryClass(..), XPropertyQuery(..), ToSelective(..), SelectiveLayoutClass(..)) where
    
import XMonad
import qualified XMonad.StackSet as W
import XMonad.Util.WindowProperties
import Data.Bifunctor

-- takes a condition and a Stack and partitions the stack into those that satisfy the condition and those that don't
filterStack :: (a -> X Bool) -> W.Stack a -> X (Maybe (W.Stack a), Maybe (W.Stack a))
filterStack c st = (\s ->
    (fmap snd <$> W.filter fst s,
     fmap snd <$> W.filter (not . fst) s))
       <$> traverse (\a -> (,a) <$> c a) st

makeStack :: [a] -> [a] -> Maybe (W.Stack a)
makeStack a (b:bs)  = Just $ W.Stack b a bs
makeStack (a:as) [] = Just $ W.Stack a as []
makeStack [] [] = Nothing

grabOne :: (a -> X Bool) -> W.Stack a -> X (Maybe a, Maybe (W.Stack a))
grabOne c (W.Stack f u d) = do b <- c f
                               if b then
                                   return (Just f, makeStack u d)
                               else do
                                   (v,u') <- go u
                                   case v of
                                       Just a -> return (Just a, Just $ W.Stack f u' d)
                                       Nothing -> (\(v',d') -> (v', Just $ W.Stack f u d')) <$> go d
    where go (x:xs) = do b <- c x
                         if b then
                             return (Just x, xs)
                         else second (x:) <$> go xs
          go [] = return (Nothing,[])

-- SelectiveLayoutClass is the pretty much the same as layoutClass except there is a extra return for windows that arn't assigend a
-- position see LayoutClass documentation for usage
class (Show (layout a), Read (layout a), Typeable layout) => SelectiveLayoutClass layout a where
    runSelLayout :: layout a -> WorkspaceId -> Maybe (W.Stack a) -> Rectangle -> X ([(a,Rectangle)], Maybe (layout a), Maybe (W.Stack a))
    runSelLayout l _ ms r = maybe (emptySelLayout l r) (doSelLayout l r) ms

    doSelLayout :: layout a -> Rectangle -> W.Stack a -> X ([(a, Rectangle)], Maybe (layout a), Maybe (W.Stack a))
    doSelLayout l r s = let (rs,wins) = pureSelLayout l r s
                        in return (rs,Nothing,wins)

    pureSelLayout :: layout a -> Rectangle -> W.Stack a -> ([(a,Rectangle)], Maybe (W.Stack a))
    pureSelLayout _ r s = ([(W.focus s, r)], makeStack (W.up s) (W.down s))

    emptySelLayout :: layout a -> Rectangle -> X ([(a,Rectangle)], Maybe (layout a), Maybe (W.Stack a))
    emptySelLayout _ _ = return ([],Nothing,Nothing)

    selHandleMessage :: layout a -> SomeMessage -> X (Maybe (layout a))
    selHandleMessage l = return . selPureMessage l

    selPureMessage :: layout a -> SomeMessage -> Maybe (layout a)
    selPureMessage _ _ = Nothing

-- a class of properties that you can make querys for using data structures for use in modified layouts
-- where a read instance is required
class XPropertyQueryClass q a where
    xQuery :: q -> a -> X Bool

instance XPropertyQueryClass (XPropertyQuery a) a where
    xQuery (XPropertyQuery q) = xQuery q


instance XPropertyQueryClass Property Window where
    xQuery p w = hasProperty p w

data XPropertyQuery a = forall q. (XPropertyQueryClass q a) => XPropertyQuery q

data ToSelective q layout a = ToSelective (layout a) q deriving (Read,Show,Typeable)

instance (LayoutClass layout a, Read (layout a), XPropertyQueryClass q a, Show q, Read q, Typeable q) => SelectiveLayoutClass (ToSelective q layout) a where
    runSelLayout (ToSelective sl p) workId ms r =
        case ms of
          Nothing -> do (rects,layoutMod) <- runLayout (W.Workspace workId sl ms) r
                        return (rects, flip ToSelective p <$> layoutMod, Nothing)
          Just stack -> do (ts,fs) <- filterStack (xQuery p) stack
                           (rects,layoutMod) <- runLayout (W.Workspace workId sl ts) r
                           return $ (rects, flip ToSelective p <$> layoutMod, fs)

    selHandleMessage (ToSelective sl p) message = do update <- handleMessage sl message
                                                     return $ (flip ToSelective p) <$> update
