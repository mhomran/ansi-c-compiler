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
using namespace std;

Case::Case(string name) : Node(name) {

}

void 
Case::generate(std::ofstream& fd) {
  auto children = Node::getChildren();
  int lb2 = Label::generateLabel();

  children[0]->generate(fd); //Constant
  fd << "EQ" << endl;
  fd << "JMPF L" << lb2 << endl;
  children[1]->generate(fd); //body
  fd << "L" << lb2 << ":" << endl; //L:
  
  children[2]->generate(fd); //case/default
}
