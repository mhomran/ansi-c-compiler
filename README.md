# About

A compiler for C language 89 which is known as ANSI C.

# The repository contains

1. Lexer: a lexical analyzer written in lex.
1. Perser: a parser written in yacc.
1. Tree: a module to generate the parse tree in .dot format.
1. Compiler.cc: the main entry point of the program.
1. test: a folder contains testcases for the compiler.

# How to build the compiler

1. Install GNU `flex` and `bison` and add them to the path environement variable.
1. Install GNU `gcc` compiler.
1. Install GNU `Make`
1. (Optional) Install `Graphviz` in case you want to generate the parse tree images.
1. Change directory to the src folder.
1. run `make`

# How to run testcases

1. Change directory to the src folder.
1. run `make test INPUT=file_name.c` Replace
   `file_name.c` with the name of the test file.

# How to run testcases and show the generated parse tree

1. Change directory to the src folder.
1. run `make show INPUT=file_name.c` Replace
   `file_name.c` with the name of the test file.

# References

1. <a href="https://www.yodaiken.com/wp-content/uploads/2021/05/ansi-iso-9899-1990-1.pdf"> ANSI C specifications </a>
