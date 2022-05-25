/**
 * @file not.cc
 * @author Mohamed Hassanin
 * @brief AST node for not rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "not.hh"

Not::Not(string name) : Node(name) {

}

#include "../temp/temp.hh"

void Not::generate(std::ofstream& fd, std::vector<std::string>& stack) {
  string arg1;
  string out;

  Node::generate(fd, stack);

  fd << "NOT";
  if(!stack.empty()) { arg1 = stack.back(); stack.pop_back(); }
  out = Temp::generateTemp();
  stack.push_back(out);

  fd << " " << arg1 << " " << out << endl;
}
