/**
 * @file equal.cc
 * @author Mohamed Hassanin
 * @brief AST node for equal rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "equal.hh"

Equal::Equal(string name) 
: Node(name)
{

}


void Equal::generate(ofstream& fd) {
  Node::generate(fd);
  fd << "EQ " << endl;
}