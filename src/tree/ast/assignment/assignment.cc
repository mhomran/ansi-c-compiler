/**
 * @file assignment.cc
 * @author Mohamed Hassanin
 * @brief AST node for assignment.
 * @version 0.1
 * @date 2022-05-17
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "assignment.hh"
#include "../assign_op/assign_op.hh"

Assignment::Assignment(string name, string identifier) 
: Node(name)
, identifier{identifier} {
  
}

void Assignment::generate(std::ofstream& fd, std::vector<std::string>& stack) {
  size_t i = 0;
  string loaded;

  Node::children[i]->generate(fd, stack);
  i++;
  if(NULL == dynamic_cast<AssignOp*>(children[i])) {
    stack.push_back(identifier);
    Node::children[i]->generate(fd, stack);
    i++;
  }
  if(!stack.empty()) { loaded = stack.back(); stack.pop_back(); }
  fd << "LD " << loaded << " " << identifier << endl;
  for (; i < Node::children.size(); i++){
    if(NULL != children[i]) Node::children[i]->generate(fd, stack);
  }
}