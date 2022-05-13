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
#include <iostream>
#include "tree/tree.hh"
/* ------------------------------------------------------------------------- */

/* ------------------------- Functions prototypes -------------------------- */
int yyparse (void);
void yydtor (void);
Node* getParseTree ();
Node* getAST ();
/* ------------------------------------------------------------------------- */

/* ------------------------- Functions Definitions ------------------------- */
int 
main(void)
{
  bool ParseError;
  int ret;
  
  std::cout << "[INFO]: Start Pasing ..." << std::endl;
  ret = yyparse();
  ParseError = 0 != ret;

  std::cout << std::endl;
  
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
  }
	yydtor();
  
	return 0;
}
/* ------------------------------------------------------------------------- */