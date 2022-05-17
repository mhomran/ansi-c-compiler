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

void Assignment::generate(ofstream& fd) {
  size_t i = 0;
  Node::children[i]->generate(fd);
  i++;
  if(NULL == dynamic_cast<AssignOp*>(children[i])) {
    fd << "PUSH " << identifier << endl;
    Node::children[i]->generate(fd);
    i++;
  }
  fd << "POP " << identifier << endl;
  for (; i < Node::children.size(); i++){
    if(NULL != children[i]) Node::children[i]->generate(fd);
  }
}