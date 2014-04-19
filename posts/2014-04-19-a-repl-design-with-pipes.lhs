---
title: A REPL design with Haskell Pipes
description: Read-Eval-Print-Loop with Haskell Pipes
tags: haskell, pipes
---

Actually we're going to read a *line*, evaluate it and print the
result. Evaluation will be undefined.

> module REPL where
> 
> import           Control.Monad
> import           Data.Text
> import           Pipes
> import qualified Pipes.Prelude as P
> import           Pipes.Parse
> import           Pipes.Text    as PT
> import           Pipes.Text.IO as PT
> import           System.IO     as IO
>  
> data Cmd = Cmd
> data Result = Result deriving (Prelude.Show)
> 
> readP :: Monad m => Pipe Text Cmd m ()
> readP = undefined
> 
> evalP :: Monad m => Pipe Cmd Result m ()
> evalP = undefined
> 
> printP :: MonadIO m => Consumer Result m ()
> printP = P.print
> 
> main :: IO ()
> main = runEffect $ PT.fromHandle IO.stdin >-> readP >-> evalP >-> printP

