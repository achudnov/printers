{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE FunctionalDependencies #-}

-- | The core printer combinators. The rest (in
-- Text.Pretty.Printers.Combinators) is defined in terms of the ones
-- in this module.

module Text.Pretty.Printers.Core where

import Data.Monoid
import Data.String

-- | Basic 1-dimentional documents that can be catenated (<>) from
-- Monoid
class (Monoid d, IsString d) => Document d where


-- | A class of 2-dimentional documents with the additional notion of
-- characters whose interpreteation depends on the context.
class Document d => ContextDocument c d | c -> d where
  -- | Produce a document depending on the context
  ctxDoc :: (c -> d) -> d

class PositionContext c where
  getPosition :: c -> Pos

class OptionalContext c o | c -> o where
  getOptions :: c -> o

class LineLengthContext c where
  getLineLength :: c -> LineLength

data LineLength = Absolute Int
                | Ribbon Int

data Pos = Pos (Int, Int)

data Doc a c = Build a
             | Cat (Doc a c) (Doc a c)
             | Ctx (c -> Doc a c)
             | Empty

instance Monoid a => Monoid (Doc a c) where
  mappend (Build l) (Build r) = Build $ l <> r
  mappend Empty r = r
  mappend r Empty = r
  mappend (Cat d1 d2) d3 = d1 <> d2 <> d3
  mappend d1 (Cat d2 d3) = d1 <> d2 <> d3
  mempty = Empty
