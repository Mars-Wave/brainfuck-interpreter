# Brainfuck Parser and Interpreter in Haskell

This project is a haskell parser (one-shot lexer) and interpreter for Brainfuck code.

## What is Brainfuck?
> Brainfuck is an esoteric programming language created in 1993 by Swiss student Urban Müller. Designed to be extremely minimalistic, the language consists of only eight simple commands, a data pointer, and an instruction pointer.
> — [*Wikipedia: Brainfuck*](https://en.wikipedia.org/wiki/Brainfuck)

### Cool facts
- Brainfuck is turing complete [*muppetlabs*] (https://www.muppetlabs.com/~breadbox/bf/)
- Brainfuck has a very small compiler

## Instructions
The eight commands in Brainfuck are:

- `>` - Move the pointer to the right
- `<` - Move the pointer to the left
- `+` - Increment the current cell value
- `-` - Decrement the current cell value
- `.` - Output the value of the current cell as an ASCII character
- `,` - Input a character and store its ASCII value in the current cell
- `[` - Jump to the matching `]` if the current cell value is zero
- `]` - Jump to the matching `[` if the current cell value is not zero

All other characters are considered comments, which means you can embed a help message in between some math calculations that look pseudo-random in a notepad if you need to, and this interpreter will output the message for you ;)

## Features

- Lexes and Parses Brainfuck code in 1 step per command
- Ensures bracket matching, the only Parse-worthy operation
- Interprets Brainfuck programs
- Handles input and output operations
- Supports both file-based and interactive modes
- Includes example Brainfuck programs

## Building the Project
To build the project, you need the GHC (Glasgow Haskell Compiler) and Cabal. Then run:

```bash
cd brainfuck-interpreter
cabal build
```

## Usage

### Running a Brainfuck Program from a File

```bash
cabal run brainfuck-interpreter examples/hello_world.bf
```

This will prompt you for input (if needed by the program) and then display the output.

For example:

```bash
cabal run brainfuck-interpreter examples/subtract.bf
```

Should be ran with two, one-digit numbers, like:
```bash
32
```

To have an output of:
```bash
1
```

### Interactive Mode

```bash
cabal run brainfuck-interpreter
```

Argumentless starts the interactive mode, where you can enter Brainfuck programs in one line, and see their output (no memory state visualization). Type 'quit' to exit.

## Example Programs

The `examples` directory contains several Brainfuck programs:

- `hello_world.bf` - Prints "Hello World!"
- `hello_world_fixed.bf` - Another version of Hello World
(there are also other versions of hello_world)
- `subtract.bf` - Subtracts the second input number from the first
- `alphabet.bf` - Outputs the representable domain of characters
- `name.bf` - Outputs a short name

## Project Structure

- `src/Parser.hs` - Parser and one-shot Lexer
- `src/Interpreter.hs` - Interpreter
- `src/Main.hs` - The logic and CLI interface
- `examples/` - Example Brainfuck programs

## Interpreter

The interpreter has the pointer to the current cell, the program counter and memory state, executing the program.

## Memory Model

The memory is implemented as a map from cell indices to cell values, with a pointer to the current cell. This allows for an "infinite" tape in both directions. Cell values wrap around from 255 to 0 and from 0 to 255.

## License

This project is licensed under the MIT License.
