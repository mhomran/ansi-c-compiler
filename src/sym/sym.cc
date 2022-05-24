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
#include <string>
#include <fstream>
#include "sym.hh"
using namespace std;

Symbol::Symbol(string name, int scope, int line)
: name{name}
, scope{scope}
, line{line} {

}

int Symbol::getScope(void) {
  return scope;
}

Symbol::~Symbol() {

}

void Symbol::print(ofstream&fd) {
  fd << 
  "<tr>" <<
    "<td>" << name << "</td>\n"
    "<td>" << scope << "</td>\n"
    "<td>" << line << "</td>\n"
  ;
}

int Symbol::getLine(void) {
  return line;
}