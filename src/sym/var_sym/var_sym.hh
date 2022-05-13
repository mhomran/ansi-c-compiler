/**
 * @file var_sym.hh
 * @author Mohamed Hassanin Mohamed.
 * @brief A variable is a symbol which represents a variable 
 * in the language.
 * @version 0.1
 * @date 2022-05-12
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../sym.hh"
#include "../datatype.hh"

class VarSymbol : public Symbol {
  Datatype datatype;

  public:
  VarSymbol(string name, int scope, Datatype);
};