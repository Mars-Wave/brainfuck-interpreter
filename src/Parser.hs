{- |
Module      : Parser
Description : Parser for Brainfuck language
Copyright   : (c) 2025
license: MIT
Author: MarsWave
This module provides functionality to parse Brainfuck code into tokens
that can be interpreted by the Interpreter module.
It doubles as a lexer, since the syntax of Brainfuck is so simple
that it does not need type value pairs, each token matches a
character, which matches a command.
-}
module Parser (
  BFToken (..),
  BFProgram,
  parseBF,
  validateBF,
) where

-- | Brainfuck tokens representing the 8 commands
data BFToken
  = MoveRight -- > Moves the pointer to the right
  | MoveLeft -- < Moves the pointer to the left
  | Increment -- + Increments the current cell value
  | Decrement -- - Decrements the current cell value
  | Output -- . Outputs the value of the current cell
  | Input -- , Reads input into the current cell
  | LoopStart -- [ Starts a loop
  | LoopEnd -- ] Ends a loop
  deriving (Show, Eq)

-- | A Brainfuck program is a list of tokens
type BFProgram = [BFToken]

{- | Parse a string into a Brainfuck program
This function filters out any characters that are not valid
and converts the remaining characters into BFToken values.
-}
parseBF :: String -> BFProgram
parseBF = map charToToken . filter isBFChar

{- | Convert a character to a Brainfuck token
Each character is mapped to its corresponding BFToken
-}
charToToken :: Char -> BFToken
charToToken '>' = MoveRight
charToToken '<' = MoveLeft
charToToken '+' = Increment
charToToken '-' = Decrement
charToToken '.' = Output
charToToken ',' = Input
charToToken '[' = LoopStart
charToToken ']' = LoopEnd
charToToken _ = error "Invalid Brainfuck character"

-- | Check if a character is a valid Brainfuck command
isBFChar :: Char -> Bool
isBFChar c = c `elem` "><+-.,[]"

{- | Validate a Brainfuck program for balanced brackets
This ensures that every '[' has a matching ']' and vice versa
-}
validateBF :: BFProgram -> Bool
validateBF = validate 0
 where
  validate :: Int -> BFProgram -> Bool
  validate 0 [] = True -- All brackets are matched
  validate _ [] = False -- Unmatched opening brackets remain
  validate n (LoopStart : xs) = validate (n + 1) xs
  validate n (LoopEnd : xs)
    | n <= 0 = False -- Unmatched closing bracket
    | otherwise = validate (n - 1) xs
  validate n (_ : xs) = validate n xs
