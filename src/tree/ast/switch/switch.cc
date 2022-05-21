/**
 * @file switch.cc
 * @author Mohamed Hassanin
 * @brief AST node for the switch rule.
 * @version 0.1
 * @date 2022-05-21
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include <iostream>
#include "switch.hh"
#include "../label/label.hh"
using namespace std;

Switch::Switch(string name) : Node(name) {

}

void 
Switch::generate(std::ofstream& fd) {
  Node::generate(fd);
}
