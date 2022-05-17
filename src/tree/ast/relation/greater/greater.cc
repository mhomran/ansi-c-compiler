/**
 * @file greater.cc
 * @author Mohamed Hassanin
 * @brief AST node for greater rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "greater.hh"

Greater::Greater(string name) 
: Node(name)
{

}


void Greater::generate(ofstream& fd) {
  Node::generate(fd);
  fd << "GR " << endl;
}