# About

A compiler for C language 89 which is known as ANSI C.

# The repository contains

1. Lexer: a lexical analyzer written in lex.
1. Perser: a parser written in yacc.

# How to build the compiler

1. Install GNU `flex` and `bison` and add them to the path environement variable.
1. Install GNU `gcc` compiler.
1. Install GNU `Make`
1. Change directory to the src folder.
1. run `make`

# How to run testcases

1. Change directory to the src folder.
1. run `make test INPUT=file_name.c` Replace
   `file_name.c` with the name of the test file.
