/**
 * @file bitwise_xor.cc
 * @author Mohamed Hassanin
 * @brief AST node for bitwise_xor rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "bitwise_xor.hh"
#include "../bitwise/bitwise.hh"

BitwiseXor::BitwiseXor(string name) : BinaryOp(name) {

}


void 
BitwiseXor::generate(std::ofstream& fd, std::vector<std::string>& stack) {
  // check for float numbers
  Bitwise::checkFloat(this);

  Node::generate(fd, stack);
  fd << "BITWISE_XOR";
  BinaryOp::generate(fd, stack);
}
