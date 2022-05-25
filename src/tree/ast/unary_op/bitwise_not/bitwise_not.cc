/**
 * @file bitwise_not.cc
 * @author Mohamed Hassanin
 * @brief AST node for bitwise_not rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "bitwise_not.hh"
#include "../temp/temp.hh"

BitwiseNot::BitwiseNot(string name) : Node(name) {

}
void BitwiseNot::generate(std::ofstream& fd, std::vector<std::string>& stack) {
  string arg1;
  string out;

  Node::generate(fd, stack);
  fd << "BITWISE_NOT";

  if(!stack.empty()) { arg1 = stack.back(); stack.pop_back(); }
  out = Temp::generateTemp();
  stack.push_back(out);

  fd << " " << arg1 << " " << out << endl;
}
