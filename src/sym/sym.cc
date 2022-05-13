/**
 * @file sym.cc
 * @author Mohamed Hassanin
 * @brief A data structure for the symbol in the symbol tables.
 * @version 0.1
 * @date 2022-05-12
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include <iostream>
#include "sym.hh"
using namespace std;

Symbol::Symbol(string name, int scope, int line)
: name{name}
, scope{scope}
, line{line} {

}

int Symbol::getScope() {
  return scope;
}

Symbol::~Symbol() {

}

void Symbol::print() {
  cout << name << endl;
}

int Symbol::getLine(void) {
  return line;
}