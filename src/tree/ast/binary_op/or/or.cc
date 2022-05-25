/**
 * @file or.cc
 * @author Mohamed Hassanin
 * @brief AST node for or rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "or.hh"

Or::Or(string name) : BinaryOp(name) {

}
void Or::generate(std::ofstream& fd, std::vector<std::string>& stack) {
  Node::generate(fd, stack);
  fd << "OR";
  BinaryOp::generate(fd, stack);
}
