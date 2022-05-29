/**
 * @file while.cc
 * @author Mohamed Hassanin
 * @brief A while node for while loop.
 * @version 0.1
 * @date 2022-05-20
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include <iostream>
#include "while.hh"
#include "../label/label.hh"
using namespace std;

While::While(string name)
: Node(name) {

}

void 
While::generate(std::ofstream& fd, std::vector<std::string>& stack) {
  int lbl1 = Label::generateLabel();
  int lbl2 = Label::generateLabel();
  std::string arg1;

  fd << "L" << lbl1 << ":" << endl;
  auto children = Node::getChildren();
  children[0]->generate(fd, stack); //expression
  if(!stack.empty()) { arg1 = stack.back(); stack.pop_back(); }
  fd << "JMPF " << arg1 << " " << "L" << lbl2 << endl;  
  children[1]->generate(fd, stack); //body
  fd << "JMP " << "L" << lbl1 << endl; //back to the expression
  fd << "L" << lbl2 << ":" << endl;
}