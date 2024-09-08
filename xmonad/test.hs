import Data.Int
import Data.Binary (Word32)
import Data.Bifunctor (second)

data Rectangle = Rectangle Int32 Int32 Word32 Word32 deriving Show

layoutTree :: Int32 -> BinarySpaceTree () Int32 String -> [(String,Rectangle)]
layoutTree space t = layoutATree (width at) (height at) at
    where annotate :: BinarySpaceTree () Int32 String -> BinarySpaceTree (Int32,Int32) Int32 String
          annotate (Split _ Horizontal a b) = Split (width aa + width ab + space, max (height aa) (height ab)) Horizontal aa ab
            where aa = annotate a
                  ab = annotate b
          annotate (Split _ Vertical a b) = Split (max (width aa) (width ab), height aa + height ab + space) Vertical aa ab
            where aa = annotate a
                  ab = annotate b
          annotate (Single win h w) = Single win h w

          at = annotate t

          height :: BinarySpaceTree (Int32,Int32) Int32 a -> Int32
          height (Split (_,h) _ _ _) = h
          height (Single _ _ h) = h

          width :: BinarySpaceTree (Int32,Int32) Int32 a -> Int32
          width (Split (w,_) _ _ _) =  w
          width (Single _ w _) = w

          layoutATree :: Int32 -> Int32 -> BinarySpaceTree (Int32,Int32) Int32 String -> [(String,Rectangle)]
          layoutATree wa ha (Single a _ _) = [(a, Rectangle (wa `div` 2) (ha `div` 2) (fromIntegral wa) (fromIntegral ha))]
          layoutATree wa ha (Split (w,h) Horizontal t1 t2) = shift' (-(hp - a1 `div` 2),0)
                                                                   (layoutATree a1 ha t1)
                                                          ++ shift' (hp - a2 `div` 2,0)
                                                                   (layoutATree a2 ha t2)
            where w1 = width t1
                  w2 = width t2
                  a = wa - w - space -- extra space to allocate
                  wt = w1 + w2 -- total space ocupied by two sides
                  a1 = w1 + a * (w1 `div` wt)
                  a2 = w2 + a * (w2 `div` wt)
                  hp = (wa + space) `div` 2


          layoutATree wa ha (Split (w,h) Vertical t1 t2) = (shift' (0, -(hp - a1 `div` 2)))
                                                                   (layoutATree a1 ha t1)
                                                          ++ (shift' (0, hp - a2 `div` 2))
                                                                   (layoutATree a2 ha t2)
            where h1 = height t1
                  h2 = height t2
                  a = ha - h - space -- extra space to allocate
                  ht = h1 + h2 -- total space ocupied by two sides
                  a1 = h1 + a * (h1 `div` ht)
                  a2 = h2 + a * (h2 `div` ht)
                  hp = (ha + space) `div` 2

data SplitDir = Horizontal | Vertical deriving (Show,Read)
data BinarySpaceTree an s a = Split an SplitDir (BinarySpaceTree an s a) (BinarySpaceTree an s a) -- direction to split and two sides
                       | Single a s s deriving (Show,Read) -- window and base x and base y


shift :: (Int32,Int32) -> Rectangle -> Rectangle
shift (x,y) (Rectangle rx ry rh rw) = Rectangle (x + rx) (y + ry) rh rw

shift' a = map (second (shift a))

testLayout :: BinarySpaceTree () Int32 String
testLayout = Single "hello" 40 60

dashLayout :: BinarySpaceTree () Int32 String
dashLayout = Split () Horizontal leftCom (Split () Horizontal centerCom (Single "galculator" 400 700))

centerCom = Split () Vertical (Single "taskell" 64 64) (Single "scratchpad" 700 200)

leftCom = Split () Vertical (Single "xclock" 64 64) (Single "top" 64 600)
