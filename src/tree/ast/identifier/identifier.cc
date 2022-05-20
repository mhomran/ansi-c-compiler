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


void Identifier::generate(ofstream& fd) {
  fd << "PUSH " << Node::name << endl;
  //connected ast nodes
  Node::generate(fd);
}

Datatype Identifier::getDatatype() {
  return dt;
}