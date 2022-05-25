/**
 * @file div.cc
 * @author Mohamed Hassanin
 * @brief AST node for div rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "div.hh"

Div::Div(string name) : BinaryOp(name) {

}
void Div::generate(std::ofstream& fd, std::vector<std::string>& stack) {
  Node::generate(fd, stack);
  fd << "DIV";
  BinaryOp::generate(fd, stack);
}
