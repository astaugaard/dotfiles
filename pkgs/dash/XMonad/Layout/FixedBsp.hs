{-# LANGUAGE TypeSynonymInstances #-}
-- {-# LANGUAGE ExistentialQuantification #-} -- needed to aviod no skolem info panic
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleContexts #-}
module XMonad.Layout.FixedBsp (FixedBsp, FixedBspLayout, splitHorizontal, splitVertical, singleWindow, fixedBspLayout) where
    
import XMonad.Layout.SelectiveLayout
import Data.Int
import Data.Maybe
import Data.Bifunctor
import qualified XMonad.StackSet as W
import XMonad

center :: Rectangle -> (Int32,Int32)
center (Rectangle x y w h) = (x + (toEnum (fromEnum w) `div` 2), y + (toEnum (fromEnum h) `div` 2))

newtype FixedBsp q a = FixedBsp {tree :: (BinarySpaceTree () (Maybe Int32) q)} deriving (Show, Read)
data FixedBspLayout q a = FixedBspLayout (FixedBsp q a) Int32 deriving (Show, Read)

data SplitDir = Horizontal | Vertical deriving (Show, Read)

data BinarySpaceTree an s a
  = Split an SplitDir (BinarySpaceTree an s a) (BinarySpaceTree an s a) -- direction to split and two sides
  | Single a s s Bool
  deriving (Show, Read) -- window and base x and base y

split :: SplitDir -> FixedBsp q a -> FixedBsp q a -> FixedBsp q a
split d a b = FixedBsp $ Split () d (tree a) $ tree b

splitHorizontal :: FixedBsp q a -> FixedBsp q a -> FixedBsp q a
splitHorizontal = split Horizontal

splitVertical :: FixedBsp q a -> FixedBsp q a -> FixedBsp q a
splitVertical = split Vertical

singleWindow :: Maybe Int32 -> Maybe Int32 -> q -> FixedBsp q a
singleWindow mx my p = FixedBsp $ Single p mx my True

fixedBspLayout :: FixedBsp q a -> Integer -> FixedBspLayout q a
fixedBspLayout fbsp space = FixedBspLayout fbsp $ toEnum $ fromEnum space

grabWins :: XPropertyQueryClass q a => BinarySpaceTree an s q -> Maybe (W.Stack a) -> X (Maybe (BinarySpaceTree an s a), Maybe (W.Stack a))
grabWins (Split an d t1 t2) st = do
  (t1', newStack) <- grabWins t1 st -- :: X (Maybe (BinarySpaceTree an s a), Maybe (W.Stack a))
  (t2', finalStack) <- grabWins t2 newStack
  return $ case t1' of
    Nothing -> (t2', finalStack)
    Just t -> case t2' of
      Just t' -> (Just (Split an d t t'), finalStack)
      Nothing -> (Just t, finalStack)
grabWins (Single query width height True) (Just st) =
  (\(grabbed, newStack) -> ((\g -> Single g width height True) <$> grabbed, newStack))
    <$> grabOne (xQuery query) st
grabWins _ _ = pure (Nothing, Nothing)

instance (XPropertyQueryClass q Window, Show q, Read q, Typeable q) => SelectiveLayoutClass (FixedBspLayout q) Window where
  doSelLayout (FixedBspLayout (FixedBsp bsp) space) rect stack =
      do (bspWithWins, resultStack) <- grabWins bsp (Just stack) -- :: (Maybe BinarySpaceTree () (Maybe Int32) Window, W.Stack Window)
         case bspWithWins of
           Nothing -> return ([],Nothing,resultStack)
           Just bspWithWins' -> do
             bspWithSize <- toSizes bspWithWins'
             let rects = shift' (center rect) $ layoutTree space bspWithSize
             return (rects,Nothing,resultStack)

toSizes :: BinarySpaceTree b (Maybe Int32) Window -> X (BinarySpaceTree b Int32 Window)
toSizes (Split an d a b) = Split an d <$> toSizes a <*> toSizes b
toSizes (Single win a b bo) = do (x,y) <- size
                                 let x' = fromMaybe x a
                                     y' = fromMaybe y b
                                 return $ (Single win x' y' bo :: BinarySpaceTree b Int32 Window)
    where size :: X (Int32,Int32)
          size = withDisplay $ \d -> do sh <- io $ getWMNormalHints d win
                                        return $ case sh_base_size sh of
                                                  Nothing -> case sh_min_size sh of
                                                                 Just (x,y) -> (fromIntegral x, fromIntegral y)
                                                                 Nothing -> (64,64)
                                                  Just (x,y) -> (fromIntegral x, fromIntegral y)



layoutTree :: Int32 -> BinarySpaceTree () Int32 a -> [(a,Rectangle)]
layoutTree space t = layoutATree (width at) (height at) at
    where annotate :: BinarySpaceTree () Int32 a -> BinarySpaceTree (Int32,Int32) Int32 a
          annotate (Split _ Horizontal a b) = Split (width aa + width ab + space, max (height aa) (height ab)) Horizontal aa ab
            where aa = annotate a
                  ab = annotate b
          annotate (Split _ Vertical a b) = Split (max (width aa) (width ab), height aa + height ab + space) Vertical aa ab
            where aa = annotate a
                  ab = annotate b
          annotate (Single win h w b) = Single win h w b

          at = annotate t

          height :: BinarySpaceTree (Int32,Int32) Int32 a -> Int32
          height (Split (_,h) _ _ _) = h
          height (Single _ _ h _) = h

          width :: BinarySpaceTree (Int32,Int32) Int32 a -> Int32
          width (Split (w,_) _ _ _) =  w
          width (Single _ w _ _) = w

          layoutATree :: Int32 -> Int32 -> BinarySpaceTree (Int32,Int32) Int32 a -> [(a,Rectangle)]
          layoutATree wa ha (Single a _ _ _) = [(a, Rectangle (-(wa `div` 2)) (-(ha `div` 2)) (fromIntegral wa) (fromIntegral ha))]
          layoutATree wa ha (Split (w,_) Horizontal t1 t2) = shift' (-hp + a1 `div` 2,0)
                                                                   (layoutATree a1 ha t1)
                                                          ++ shift' (hp - a2 `div` 2,0)
                                                                   (layoutATree a2 ha t2)
            where w1 = width t1
                  w2 = width t2
                  a = wa - w - space -- extra space to allocate
                  wt = w1 + w2 -- total space ocupied by two sides
                  a1 = allocAdd a wt w1
                  a2 = allocAdd a wt w2
                  hp = (wa + space) `div` 2

          layoutATree wa ha (Split (_,h) Vertical t1 t2) = shift' (0,-hp + a1 `div` 2)
                                                                   (layoutATree wa a1 t1)
                                                          ++ shift' (0, hp - a2 `div` 2)
                                                                   (layoutATree wa a2 t2)
            where h1 = height t1
                  h2 = height t2
                  a = ha - h - space -- extra space to allocate
                  ht = h1 + h2 -- total space ocupied by two sides
                  a1 = h1 + ((a * h1) `div` ht)
                  a2 = h2 + ((a * h2) `div` ht)
                  hp = (ha + space) `div` 2

          allocAdd :: Int32 -> Int32 -> Int32 -> Int32
          allocAdd amount sumOfCompetitors currentOcupation = currentOcupation + ((amount * currentOcupation) `div` sumOfCompetitors)


shift :: (Int32,Int32) -> Rectangle -> Rectangle
shift (x,y) (Rectangle rx ry rh rw) = Rectangle (x + rx) (y + ry) rh rw


shift' :: (Int32,Int32) -> [(a,Rectangle)] -> [(a,Rectangle)]
shift' a = map (second (shift a))
