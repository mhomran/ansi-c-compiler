/**
 * @file identifier.cc
 * @author Mohamed Hassanin
 * @brief AST node for identifier rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "identifier.hh"

Identifier::Identifier(string name, Datatype dt) 
: Node(name), dt{dt}
{

}


void Identifier::generate(std::ofstream& fd, std::vector<std::string>& stack) {
  stack.push_back(Node::name);
  //connected ast nodes
  Node::generate(fd, stack);
}

Datatype Identifier::getDatatype() {
  return dt;
}