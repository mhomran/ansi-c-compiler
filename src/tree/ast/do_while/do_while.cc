/**
 * @file do_while.cc
 * @author Mohamed Hassanin
 * @brief A do_while node for do_while loop.
 * @version 0.1
 * @date 2022-05-20
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include <iostream>
#include "do_while.hh"
#include "../label/label.hh"
using namespace std;

DoWhile::DoWhile(string name)
: Node(name) {

}

void 
DoWhile::generate(std::ofstream& fd) {
  auto children = Node::getChildren();
  int lbl1 = Label::generateLabel();
  fd << "L" << lbl1 << ":" << endl;
  children[0]->generate(fd); //body
  children[1]->generate(fd); //expression
  fd << "JMPT " << "L" << lbl1 << endl;
}