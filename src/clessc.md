# C++ LESS Compiler

This is a implementation of the LESS compiler found on lesscss.org in
C++. LESS is an extension for CSS that adds variables, nested rules,
functions and operations to make style-sheets easier to write. The
LESS code is compiled to CSS with a compiler such as this one.

## Download
- [Source on Github](https://github.com/BramvdKroef/clessc)

## Installation

To compile just run 'make'. g++ or another c++ compiler is required. If
you are using a compiler other than g++ you'll need to change the
Makefile.

After compiling you will have the binary lessc. You can run 'make
install' as root to install the binary to /usr/local/bin/.

Note that the original compiler is also named lessc. If you already
have another LESS CSS compiler installed you should rename the lessc
binary you just created before copying.

## Usage

To compile the LESS stylesheet stylesheet.less and write the resulting
CSS to stylsheet.css run:

    lessc stylesheet.less > stylesheet.css

or:

    lessc stylesheet.less -o stylesheet.css

