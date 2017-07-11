# Source code interpreter
 
This project parses a simple, math based code and executes it. It
consists of a Tokenizer, Parser, Symbol table, a library that defines
functions called from the code and a class that executes the parse
tree.

Here is an example:

    -1 + 1 * 2 - 5 / (7 + 25)
    > 0.84375

Vectors and matrices are supported:

    1 2 3 + 3 2 1
    > 4 4 4 

A variable and a unary function (takes one argument, prefixed):

    x = 9 count
    > 1 2 3 4 5 6 7 8 9

A binary function (takes two arguments, one on each side):

    x2 = x reshape 3 3
    > 1 2 3 
      4 5 6 
      7 8 9

A comparative function, that returns 1 or 0:

    5 <= 3
    > 0

New functions can be defined:

    def unary increment (num) {
      num + 1
    } 
    10 increment
    > 11
    
    def binary times(a b) {
      tmp = a
      tmp * b
    }
    10 times 6
    > 60

Because this is was an assignment in university the code falls under
the license of the university and can't be hosted on git hub. 

## Download

- [Source Archive](/files/interpreter.tar.bz2)

## Building

Download the source and build it. A C++ compiler and make are
required. 

The Makefile is configured to use g++. If you use a different compiler
you'll need to change the CC variable at the top of the Makefile. 

To compile run:

    make

And that's it. You will now have a binary called Interpreter.

## Usage

On the command line go to the directory where the Interpreter is and
run:

    Interpreter

The interpreter will ask you to enter some code and will execute each
line as you enter it. Alternatively you can give it a file. The source
includes an example file that you can use:

    Interpreter example.txt


