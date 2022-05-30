/**
 * @file var_sym.cc
 * @author Mohamed Hassanin Mohamed.
 * @brief A variable is a symbol which represents a variable 
 * in the language.
 * @version 0.1
 * @date 2022-05-12
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include <fstream>
#include "var_sym.hh"
using namespace std;

VarSymbol::VarSymbol(string name, int scope, int line,
 Datatype datatype, bool isConst, bool isInitialized) 
: Symbol(name, scope, line)
, datatype{datatype}
, isConst{isConst}
, isInitialized{isInitialized}
, isUsed{false}
{
}

bool VarSymbol::getIsUsed(void) {
  return isUsed;
}

void VarSymbol::setIsUsed(bool isUsed) {
  this->isUsed = isUsed;
}

bool VarSymbol::getIsInitialized(void) {
  return isInitialized;
}

void VarSymbol::setIsInitialized(bool isInitialized) {
  this->isInitialized = isInitialized;
}
bool VarSymbol::getIsConst(void) {
  return isConst;
}

void VarSymbol::setIsConst(bool isConst) {
  this->isConst = isConst;
}

Datatype VarSymbol::getDatatype() {
  return datatype;
}

void VarSymbol::print(ofstream&fd) {
  Symbol::print(fd);
  fd <<
  "<td>" << "var" << "</td>\n"
  "<td>" << (isConst ? "const " : "") <<
  Datatype_ToString(datatype) << "</td>\n"
  "</tr>\n"
  ;
}
