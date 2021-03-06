/**
 * @file compiler.cc
 * @author Mohamed Hassanin Mohamed
 * @brief A compiler for C language 89 which is known as ANSI C.
 * @version 0.1
 * @date 2022-04-25
 * 
 * @copyright Copyright (c) 2022
 * 
 */

/* ------------------------------- includes -------------------------------- */
#include <vector>
#include <string>
#include <iostream>
#include "tree/tree.hh"
/* ------------------------------------------------------------------------- */

/* ------------------------- Functions prototypes -------------------------- */
int yyparse (void);
void yydtor (void);
void yyctor (void);
Node* getParseTree ();
Node* getAST ();
std::ofstream& getErrorFd ();

/* ------------------------------------------------------------------------- */

/* ------------------------- Functions Definitions ------------------------- */
int 
main(void)
{
  bool ParseError;
  int ret;
  
  yyctor();
  
  try {
    std::cout << "[INFO]: Start Parsing ..." << std::endl;
    ret = yyparse();
    ParseError = 0 != ret;

    if(ParseError) {
      std::cout << "[ERROR]: Parser Failed. Exiting..." << std::endl;
    }
    else {
      std::cout << "[INFO]: Finish Parsing." << std::endl;

      std::cout << "[INFO]: Start Writing parse_tree.dot file..." << std::endl;
      Node* parseTree = getParseTree();
      Node::PrintParseTree(parseTree, "parse_tree");
      std::cout << "[INFO]: Finish Writing parse_tree.dot file." << std::endl;
      
      std::cout << "[INFO]: Start Writing AST.dot file..." << std::endl;
      Node* AST = getAST();
      Node::PrintParseTree(AST, "AST");
      std::cout << "[INFO]: Finish Writing AST.dot file." << std::endl;

      std::cout << "[INFO]: Start Writing output.txt file..." << std::endl;
      std::ofstream fd;
      fd.open ("output.txt");
      std::vector<std::string> stack;
      AST->generate(fd, stack);
      fd.close();
      std::cout << "[INFO]: Finish Writing output.txt file." << std::endl;
    }
  }
  catch(std::string error)
  {
    std::ofstream& er_fd = getErrorFd();
    std::cout << error;
    er_fd << error;
  }
	yydtor();
  
	return 0;
}
/* ------------------------------------------------------------------------- */