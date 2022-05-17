/**
 * @file greater_equal.cc
 * @author Mohamed Hassanin
 * @brief AST node for greater_equal rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "greater_equal.hh"

GreaterEqual::GreaterEqual(string name) 
: Node(name)
{

}


void GreaterEqual::generate(ofstream& fd) {
  Node::generate(fd);
  fd << "GRE " << endl;
}