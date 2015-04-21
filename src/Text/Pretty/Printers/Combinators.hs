{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE RankNTypes #-}
module Text.Pretty.Printers.Combinators where

import Text.Pretty.Printers.Core
import Data.List
import Data.Monoid

hcat :: Document d => [d] -> d
hcat = mconcat

(<+>) :: (ContextDocument d c, PositionContext c, LineLengthContext c) => d -> d -> d
d1 <+> d2 = undefined

hsep :: Document d => [d] -> d
hsep = undefined

withPos :: (ContextDocument c d, PositionContext c) => (Pos -> d) -> d
withPos f = ctxDoc (f . getPosition)

optional :: (ContextDocument c d, OptionalContext c Bool, Document x) => [a] -> x -> d
optional = undefined

printOptional :: (ContextDocument c d, OptionalContext c Bool, Document r) => [a] -> d -> r
printOptional = undefined
