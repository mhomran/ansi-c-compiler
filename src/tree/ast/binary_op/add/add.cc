/**
 * @file add.cc
 * @author Mohamed Hassanin
 * @brief AST node for add rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "add.hh"
#include "../temp/temp.hh"

Add::Add(string name) : BinaryOp(name) {

}
void Add::generate(std::ofstream& fd, std::vector<std::string>& stack) {
  Node::generate(fd, stack);

  fd << "ADD";

  BinaryOp::generate(fd, stack);
}
