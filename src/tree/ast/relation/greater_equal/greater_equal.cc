/**
 * @file greater_equal.cc
 * @author Mohamed Hassanin
 * @brief AST node for greater_equal rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "greater_equal.hh"

GreaterEqual::GreaterEqual(string name) 
: BinaryOp(name)
{

}


void GreaterEqual::generate(std::ofstream& fd, std::vector<std::string>& stack) {
  Node::generate(fd, stack);
  fd << "GRE";
  BinaryOp::generate(fd, stack);
}