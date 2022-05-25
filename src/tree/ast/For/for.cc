/**
 * @file for.cc
 * @author Mohamed Hassanin
 * @brief A for node for for loop.
 * @version 0.1
 * @date 2022-05-20
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include <iostream>
#include "for.hh"
#include "../label/label.hh"
using namespace std;

For::For(string name)
: Node(name) {

}

void 
For::generate(std::ofstream& fd, std::vector<std::string>& stack) {
  auto children = Node::getChildren();
  int lbl1 = Label::generateLabel();
  int lbl2 = Label::generateLabel();

  children[0]->generate(fd, stack); // first stmt
  fd << "L" << lbl1 << ":" << endl;
  children[1]->generate(fd, stack); //expression
  fd << "JMPF " << "L" << lbl2 << endl;
  children[3]->generate(fd, stack); //body
  children[2]->generate(fd, stack); //last stmt
  fd << "JMP " << "L" << lbl1 << endl; //back to the expression
  fd << "L" << lbl2 << ":" << endl;
}