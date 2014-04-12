---
title: Parsing in Pipes
description: My first serious attempt on Haskell Pipes
tags: haskell, pipes
---

We're going to add a new security module for our product which is
going to be a web application firewall testing tool. After made a
briefing about it's basic features, we take the lean way and planned
to introduce a command-line program which reads requests from a file,
does the IO job and outputs the results as Secure or Insecure.

This lead me to a new opportunity to test Haskell Pipes Library. So I
tried to make a prototype for a simple language to demnonstrate basic
features of Pipes.

Given any Text stream, it should parse Text and produce stream of
Cmd types.


``` haskell
{-# LANGUAGE OverloadedStrings        #-}
module Main where

--------------------------------------------------------------------------------
import           Control.Applicative
import           Control.Monad
import           Data.Text.Lazy as TL
import qualified Data.Text as T
import           Pipes
import           Pipes.Safe as PS
import           Pipes.Safe.Prelude     as PS
import           Pipes.Group
import           Pipes.Parse as PP
import           Pipes.Attoparsec as PA
import qualified Data.Attoparsec.Text.Lazy as AL
import qualified Pipes.Text as PT
import qualified Pipes.Text.IO as PT
--------------------------------------------------------------------------------
import           Data.Char              (isSpace)
import qualified Pipes.Prelude          as P
import           Lens.Family
import           Lens.Family.State.Strict
--------------------------------------------------------------------------------

myFile :: TL.Text
myFile = TL.unlines [ "Put 0x30 21"
                    , "Get 0x30"
                    ]

myParser :: AL.Parser Cmd
myParser = do
  cmd <- AL.string "Get" <|> AL.string "Put"
  case cmd of
    "Get" -> Get <$> (AL.space *> AL.takeTill AL.isEndOfLine <* AL.endOfLine) 
    "Put" -> Put <$> (AL.space *> AL.takeTill isSpace)
                 <*> (AL.space *> AL.takeTill AL.isEndOfLine <* AL.endOfLine)

testParser :: PT.Text -> Either String [Cmd]
testParser = AL.parseOnly (many myParser)

-- | Pipes Tests
data Out = OutA
         | OutB
           deriving (Eq, Show)

data Cmd = Get T.Text
         | Put T.Text T.Text
         | Err T.Text      -- ^ emit errors with line nums
           deriving (Eq, Show)

cmdParsed :: (MonadSafe m)
          => Producer PT.Text m ()
          -> Producer Cmd m (Either (ParsingError, Producer PT.Text m ()) ())
cmdParsed = PA.parsed myParser

test :: (MonadSafe m) => m ()
test = do
  res <- pipeline
  case res of
    Right x       -> return ()
    Left (err, p) -> (liftIO $ print (peMessage err))
  where
    input = PT.fromLazy myFile
    pipeline = runEffect $ cmdParsed input >-> P.print

main :: IO ()
main = runSafeT $ test
```
