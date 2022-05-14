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

BitwiseXor::BitwiseXor(string name) : Node(name) {

}
void BitwiseXor::generate(std::ofstream& fd) {
  Node::generate(fd);
  fd << "BITWISE_XOR" << endl;
}
