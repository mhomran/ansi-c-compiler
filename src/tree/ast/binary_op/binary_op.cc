/**
 * @file binary_op.cc
 * @author Mohamed Hassanin
 * @brief AST node for binary_op rules
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "binary_op.hh"
#include "../temp/temp.hh"

BinaryOp::BinaryOp(string name) : Node(name) {

}

void BinaryOp::generate(std::ofstream& fd, std::vector<std::string>& stack) {
  string arg1;
  string arg2;
  string out;

  if(!stack.empty()) { arg2 = stack.back(); stack.pop_back(); }
  if(!stack.empty()) { arg1 = stack.back(); stack.pop_back(); }
  out = Temp::generateTemp();
  stack.push_back(out);

  fd << " " << arg1 << " " << arg2 << " " << out << endl;
}
