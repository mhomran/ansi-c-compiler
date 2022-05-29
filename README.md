# About

A simplified compiler for C language 89 which is known as ANSI C.

# How to build the compiler

1. Install GNU `flex` and `bison` and add them to the path environement variable.
1. Install GNU `gcc` compiler.
1. Install GNU `Make`
1. (Optional) Install `Graphviz` in case you want to generate the parse tree images.
1. (Optional) For the GUI install `python 3`, then install `pyqt5` and `pyqt5-tools` using pip.
1. run `make`

# How to run testcases

- run `make test INPUT=file_name.c` Replace
  `file_name.c` with the name of the test file.

# How to run testcases and show the generated parse tree

- run `make show_pst INPUT=file_name.c` Replace
  `file_name.c` with the name of the test file.

# How to run testcases and show the generated abstract syntax tree (AST)

- run `make show_ast INPUT=file_name.c` Replace
  `file_name.c` with the name of the test file.

# How to run testcases and show the generated symbol table

- run `make show_sym INPUT=file_name.c` Replace
  `file_name.c` with the name of the test file.

# How to run testcases and show all graphs

- run `make show_all INPUT=file_name.c` Replace
  `file_name.c` with the name of the test file.

# How to run testcases using the GUI

- `cd` to the gui folder
- run `python compiler.py`
- press `browse and compile`, then choose the test file.

# References

1. <a href="https://www.yodaiken.com/wp-content/uploads/2021/05/ansi-iso-9899-1990-1.pdf"> ANSI C specifications </a>
