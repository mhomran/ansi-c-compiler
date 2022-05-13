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

#include "var_sym.hh"

VarSymbol::VarSymbol(string name, int scope, Datatype datatype, bool isConst, bool isInitialized) 
: Symbol(name, scope)
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