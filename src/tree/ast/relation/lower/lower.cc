/**
 * @file lower.cc
 * @author Mohamed Hassanin
 * @brief AST node for lower rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "lower.hh"

Lower::Lower(string name) 
: Node(name)
{

}


void Lower::generate(ofstream& fd) {
  Node::generate(fd);
  fd << "LR " << endl;
}