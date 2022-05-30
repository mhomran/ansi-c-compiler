/**
 * @file datatype.cc
 * @author Mohamed Hassanin
 * @brief The datatypes in the language.
 * @version 0.1
 * @date 2022-05-30
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "datatype.hh"

string
Datatype_ToString(Datatype e)
{
  switch (e)
  {
    case Datatype::VOID: return "void";
    case Datatype::CHAR: return "char";
    case Datatype::SHORT: return "short";
    case Datatype::INT: return "int";
    case Datatype::LONG: return "long";
    case Datatype::FLOAT: return "float";
    case Datatype::DOUBLE: return "double";
    default: return "";
  }
}