/**
 * @file and.cc
 * @author Mohamed Hassanin
 * @brief AST node for and rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "and.hh"

And::And(string name) : BinaryOp(name) {

}
void And::generate(std::ofstream& fd, std::vector<std::string>& stack) {
  Node::generate(fd, stack);
  fd << "AND";
  BinaryOp::generate(fd, stack);
}
