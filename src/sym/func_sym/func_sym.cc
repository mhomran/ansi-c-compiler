/**
 * @file func_sym.cc
 * @author Mohamed Hassanin Mohamed.
 * @brief A function is a symbol which represents a function 
 * in the language.
 * @version 0.1
 * @date 2022-05-12
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "func_sym.hh"

FuncSymbol::FuncSymbol(string name, int scope, int line, Datatype returnDatatype)
: Symbol(name, scope, line),
returnDatatype{returnDatatype}
{

}

void FuncSymbol::InsertPar(Datatype parDatatype)
{
  this->pars.push_back(parDatatype);
}

bool FuncSymbol::IsMatchingParameters(vector<Datatype> args)
{
  bool res;
  size_t i;

  res = true;
  if(args.size() != pars.size()) {
    res =  false;
  } else {
    for(i = 0; i < args.size(); i++) {
      if(args[i] != pars[i]) {
        res = false;
        break;
      }
    }
  }

  return res;
}
