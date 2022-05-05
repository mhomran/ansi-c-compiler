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
#include "tree/tree.h"
/* ------------------------------------------------------------------------- */

/* ------------------------- Functions prototypes -------------------------- */
int yyparse (void);
Node* getParseTree ();
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

    std::cout << "[INFO]: Start Writing .dot file..." << std::endl;
    Node* parseTree = getParseTree();
    Node::PrintParseTree(parseTree);
    Node::DeleteTree(parseTree);
    std::cout << "[INFO]: Finish Writing .dot file." << std::endl;
  }
	
	return 0;
}
/* ------------------------------------------------------------------------- */