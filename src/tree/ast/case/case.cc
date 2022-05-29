/**
 * @file case.cc
 * @author Mohamed Hassanin
 * @brief AST node for the case rule.
 * @version 0.1
 * @date 2022-05-21
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include <iostream>
#include "case.hh"
#include "../label/label.hh"
#include "../temp/temp.hh"

using namespace std;

Case::Case(string name) : Node(name) {

}

void 
Case::generate(std::ofstream& fd, std::vector<std::string>& stack) {
  auto children = Node::getChildren();
  int lbl2 = Label::generateLabel();
  std::string arg1;
  std::string arg2;
  std::string out;

  //case equal
  children[0]->generate(fd, stack); //Constant
  fd << "EQ";
  if(!stack.empty()) { arg2 = stack.back(); stack.pop_back(); }
  if(!stack.empty()) { arg1 = stack.back(); /*stack.pop_back();*/ }
  out = Temp::generateTemp();
  stack.push_back(out);
  fd << " " << arg1 << " " << arg2 << " " << out << endl;

  if(!stack.empty()) { arg1 = stack.back(); stack.pop_back(); }
  fd << "JMPF " << arg1 << " " << "L" << lbl2 << endl;
  children[1]->generate(fd, stack); //body
  fd << "L" << lbl2 << ":" << endl; //L:
  
  children[2]->generate(fd, stack); //case/default
}
