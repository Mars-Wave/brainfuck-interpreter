{- |
Module      : Interpreter
Description : Interpreter for Brainfuck language
Copyright   : (c) 2025
license: MIT
Author: MarsWave

This module provides functionality to interpret Brainfuck programs
that have been parsed by the Parser module.
-}
module Interpreter (
  Memory,
  emptyMemory,
  interpret,
) where

import Data.Char (chr, ord)
import qualified Data.Map as Map
import Parser

{- | Memory is represented as a map from cell index to cell value (0-255)
with a pointer to the current cell
-}
type Memory = (Map.Map Int Int, Int)

-- | Create an empty memory with pointer at position 0
emptyMemory :: Memory
emptyMemory = (Map.empty, 0)

-- | Get the value at the current cell, defaulting to 0 if not set
getCurrentValue :: Memory -> Int
getCurrentValue (mem, ptr) = Map.findWithDefault 0 ptr mem

-- | Set the value at the current cell, ensuring it wraps around 0-255
setCurrentValue :: Int -> Memory -> Memory
setCurrentValue val (mem, ptr) = (Map.insert ptr (val `mod` 256) mem, ptr)

-- | Move the pointer right
moveRight :: Memory -> Memory
moveRight (mem, ptr) = (mem, ptr + 1)

-- | Move the pointer left
moveLeft :: Memory -> Memory
moveLeft (mem, ptr) = (mem, ptr - 1)

-- | Increment the current cell value, wrapping from 255 to 0
increment :: Memory -> Memory
increment mem = setCurrentValue (getCurrentValue mem + 1) mem

-- | Decrement the current cell value, wrapping from 0 to 255
decrement :: Memory -> Memory
decrement mem = setCurrentValue (getCurrentValue mem - 1) mem

{- | Find matching loop end for a loop start
This is used to skip a loop when the current cell is zero
-}
findMatchingEnd :: BFProgram -> Int -> Int
findMatchingEnd prog start = go (start + 1) 1
 where
  go i 0 = i - 1
  go i n
    | i >= length prog = error "Unmatched loop start"
    | prog !! i == LoopStart = go (i + 1) (n + 1)
    | prog !! i == LoopEnd = go (i + 1) (n - 1)
    | otherwise = go (i + 1) n

{- | Find matching loop start for a loop end
This is used to jump back to the start of a loop when the current cell is non-zero
-}
findMatchingStart :: BFProgram -> Int -> Int
findMatchingStart prog end = go (end - 1) 1
 where
  go i 0 = i + 1
  go i n
    | i < 0 = error "Unmatched loop end"
    | prog !! i == LoopEnd = go (i - 1) (n + 1)
    | prog !! i == LoopStart = go (i - 1) (n - 1)
    | otherwise = go (i - 1) n

{- | Interpret a Brainfuck program with given input
Returns the output produced by the program
-}
interpret :: BFProgram -> String -> String
interpret prog input = interpretWithState' prog input emptyMemory 0 ""

{- | Helper function to interpret a Brainfuck program with state and accumulate output
This is a tail-recursive implementation that builds the output string as it goes
-}
interpretWithState' :: BFProgram -> String -> Memory -> Int -> String -> String
interpretWithState' prog input mem pc output
  | pc >= length prog = output -- End of program
  | otherwise = case prog !! pc of
      MoveRight -> interpretWithState' prog input (moveRight mem) (pc + 1) output
      MoveLeft -> interpretWithState' prog input (moveLeft mem) (pc + 1) output
      Increment -> interpretWithState' prog input (increment mem) (pc + 1) output
      Decrement -> interpretWithState' prog input (decrement mem) (pc + 1) output
      Output -> interpretWithState' prog input mem (pc + 1) (output ++ [chr (getCurrentValue mem)])
      Input -> case input of
        [] -> interpretWithState' prog "" (setCurrentValue 0 mem) (pc + 1) output
        (c : cs) -> interpretWithState' prog cs (setCurrentValue (ord c) mem) (pc + 1) output
      LoopStart ->
        if getCurrentValue mem == 0
          then interpretWithState' prog input mem (findMatchingEnd prog pc + 1) output
          else interpretWithState' prog input mem (pc + 1) output
      LoopEnd ->
        if getCurrentValue mem /= 0
          then interpretWithState' prog input mem (findMatchingStart prog pc) output
          else interpretWithState' prog input mem (pc + 1) output
