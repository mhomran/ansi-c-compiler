/**
 * @file bitwise_or.cc
 * @author Mohamed Hassanin
 * @brief AST node for bitwise_or rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "bitwise_or.hh"
#include "../bitwise/bitwise.hh"

BitwiseOr::BitwiseOr(string name) : BinaryOp(name) {

}
void BitwiseOr::generate(std::ofstream& fd, std::vector<std::string>& stack) {
  // check for float numbers
  Bitwise::checkFloat(this);

  Node::generate(fd, stack);
  fd << "BITWISE_OR";
  BinaryOp::generate(fd, stack);
}
