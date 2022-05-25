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

BitwiseAnd::BitwiseAnd(string name) : BinaryOp(name) {

}

void BitwiseAnd::generate(std::ofstream& fd, std::vector<std::string>& stack) {
  // check for float numbers
  Bitwise::checkFloat(this);
  
  Node::generate(fd, stack);
  fd << "BITWISE_AND";
  BinaryOp::generate(fd, stack);
}
