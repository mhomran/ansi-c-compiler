/**
 * @file lower_equal.cc
 * @author Mohamed Hassanin
 * @brief AST node for lower_equal rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "lower_equal.hh"

LowerEqual::LowerEqual(string name) 
: Node(name)
{

}


void LowerEqual::generate(ofstream& fd) {
  Node::generate(fd);
  fd << "LRE " << endl;
}