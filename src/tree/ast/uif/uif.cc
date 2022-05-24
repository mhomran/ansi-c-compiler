/**
 * @file uif.cc
 * @author Mohamed Hassanin
 * @brief AST node for Unmatched IF rule.
 * @version 0.1
 * @date 2022-05-20
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "uif.hh"
#include "../label/label.hh"

Uif::Uif(string name) : Node(name) {

}

void 
Uif::generate(std::ofstream& fd) {
  auto children = Node::getChildren();
  int lbl2 = Label::generateLabel();
  size_t i;

  children[0]->generate(fd); //expression
  fd << "JMPF " << "L" << lbl2 << endl;
  children[1]->generate(fd); //if body
  fd << "L" << lbl2 << ":" << endl;

  for(i = 2; i < children.size(); i++) {
    children[i]->generate(fd);
  }
}