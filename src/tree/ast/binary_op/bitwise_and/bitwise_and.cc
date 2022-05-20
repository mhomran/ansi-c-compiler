/**
 * @file bitwise_and.cc
 * @author Mohamed Hassanin
 * @brief AST node for bitwise_and rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "bitwise_and.hh"
#include "../bitwise/bitwise.hh"

BitwiseAnd::BitwiseAnd(string name) : Node(name) {

}

void BitwiseAnd::generate(std::ofstream& fd) {
  // check for float numbers
  Bitwise::checkFloat(this);
  
  Node::generate(fd);
  fd << "BITWISE_AND" << endl;
}
