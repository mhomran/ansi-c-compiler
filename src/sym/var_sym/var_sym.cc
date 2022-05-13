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

VarSymbol::VarSymbol(string name, int scope, Datatype datatype) 
: Symbol(name, scope), datatype{datatype}
{
}
