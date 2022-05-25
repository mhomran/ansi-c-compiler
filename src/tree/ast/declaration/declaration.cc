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

void Declaration::generate(std::ofstream& fd, std::vector<std::string>& stack) {
  string loaded;
  fd << ".WORD " << identifier << endl;
  if(isAssigned) {
    Node::children[0]->generate(fd, stack);
    if(!stack.empty()) { loaded = stack.back(); stack.pop_back(); }
    fd << "LD " << loaded << " " << identifier << endl;
    for (size_t i=1; i < Node::children.size(); i++){
      if(NULL != children[i]) Node::children[i]->generate(fd, stack);
    }
  } else {
    Node::generate(fd, stack);
  }
}