{- |
Module      : Main
Description : Main module for Brainfuck parser and interpreter
Copyright   : (c) 2025
license: MIT
Author: MarsWave

This module provides the main functionality for running the Brainfuck parser
and interpreter, including file-based and interactive modes.
-}
module Main where

import Interpreter
import Parser
import System.Environment (getArgs)
import System.IO (hFlush, stdout)

{- | Main function to run the Brainfuck parser and interpreter
Handles command-line arguments and determines whether to run in file mode or interactive mode
-}
main :: IO ()
main = do
  args <- getArgs
  case args of
    [] -> interactiveMode
    [filename] -> runFile filename
    _ -> putStrLn "Usage: brainfuck-parser [filename]"

{- | Run a Brainfuck program from a file
Reads the file, parses it, validates it, and runs it with user input
-}
runFile :: String -> IO ()
runFile filename = do
  contents <- readFile filename
  let program = parseBF contents
  if validateBF program
    then do
      putStrLn $ "Running Brainfuck program from " ++ filename
      putStr "Input (if needed): "
      hFlush stdout
      input <- getLine
      let output = interpret program input
      putStrLn $ "Output: " ++ output
    else putStrLn "Error: Unbalanced brackets in program"

{- | Interactive mode for the Brainfuck interpreter
Allows the user to enter Brainfuck programs directly and see the results
-}
interactiveMode :: IO ()
interactiveMode = do
  putStrLn "Brainfuck Parser and Interpreter"
  putStrLn "Enter a Brainfuck program (or 'quit' to exit):"
  program <- getLine
  if program == "quit"
    then putStrLn "Goodbye!"
    else do
      let tokens = parseBF program
      if validateBF tokens
        then do
          putStr "Input (if needed): "
          hFlush stdout
          input <- getLine
          let output = interpret tokens input
          putStrLn $ "Output: " ++ output
        else putStrLn "Error: Unbalanced brackets in program"
      interactiveMode
