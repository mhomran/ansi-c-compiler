/**
 * @file func_sym.hh
 * @author Mohamed Hassanin Mohamed.
 * @brief A function is a symbol which represents a function 
 * in the language.
 * @version 0.1
 * @date 2022-05-12
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include <vector>
#include "../sym.hh"
#include "../datatype.hh"

class FuncSymbol : public Symbol {
  Datatype returnDatatype;
  vector<Datatype> pars;

  public:
  FuncSymbol(string name, int scope, Datatype returnDatatype);
  
  void InsertPar(Datatype);
  bool IsMatchingParameters(vector<Datatype> args);
};
