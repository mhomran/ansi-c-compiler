/**
 * @file default.cc
 * @author Mohamed Hassanin
 * @brief AST node for the default rule.
 * @version 0.1
 * @date 2022-05-21
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include <iostream>
#include "default.hh"
#include "../label/label.hh"
using namespace std;

Default::Default(string name) : Node(name) {

}

void 
Default::generate(std::ofstream& fd) {
  Node::generate(fd);
}
