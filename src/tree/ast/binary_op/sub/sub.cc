/**
 * @file sub.cc
 * @author Mohamed Hassanin
 * @brief AST node for sub rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "sub.hh"

Sub::Sub(string name) : BinaryOp(name) {

}
void Sub::generate(std::ofstream& fd, std::vector<std::string>& stack) {
  Node::generate(fd, stack);
  fd << "SUB";
  BinaryOp::generate(fd, stack);
}
