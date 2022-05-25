/**
 * @file mif.cc
 * @author Mohamed Hassanin
 * @brief AST node for Matched IF rule.
 * @version 0.1
 * @date 2022-05-20
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "mif.hh"
#include "../label/label.hh"

Mif::Mif(string name) : Node(name) {

}

void 
Mif::generate(std::ofstream& fd, std::vector<std::string>& stack) {
  auto children = Node::getChildren();
  int lbl1 = Label::generateLabel();
  int lbl2 = Label::generateLabel();
  children[0]->generate(fd, stack); //expression
  fd << "JMPF " << "L" << lbl2 << endl;
  children[1]->generate(fd, stack); //if body
  fd << "JMP " << "L" << lbl1 << endl; //end of else
  fd << "L" << lbl2 << ":" << endl;
  children[2]->generate(fd, stack); //else body
  fd << "L" << lbl1 << ":" << endl;
}