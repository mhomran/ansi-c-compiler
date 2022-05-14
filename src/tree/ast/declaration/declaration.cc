/**
 * @file declaration.cc
 * @author Mohamed Hassanin
 * @brief AST node for declaration rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "declaration.hh"

Declaration::Declaration(string name, VarConst* varConst, 
string identifier, bool isAssigned) 
: Node(name),
varConst{varConst},
identifier{identifier},
isAssigned{isAssigned}
{

}

void Declaration::generate(ofstream& fd) {
  fd << ".WORD " << identifier << endl;
  if(isAssigned) {
    Node::children[0]->generate(fd);
    fd << "POP " << identifier << endl;
    for (size_t i=1; i < Node::children.size(); i++){
      if(NULL != children[i]) Node::children[i]->generate(fd);
    }
  } else {
    Node::generate(fd);
  }
}