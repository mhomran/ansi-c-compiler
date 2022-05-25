/**
 * @file mul.cc
 * @author Mohamed Hassanin
 * @brief AST node for mul rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "mul.hh"

Mul::Mul(string name) : BinaryOp(name) {

}
void Mul::generate(std::ofstream& fd, std::vector<std::string>& stack) {
  Node::generate(fd, stack);
  fd << "MUL";
  BinaryOp::generate(fd, stack);
}
