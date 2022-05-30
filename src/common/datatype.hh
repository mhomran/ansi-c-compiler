/**
 * @file datatype.hh
 * @author Mohamed Hassanin
 * @brief The datatypes in the language.
 * @version 0.1
 * @date 2022-05-12
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once
#include <string>
using namespace std;

enum class Datatype { 
  VOID,
  CHAR,
  SHORT,
  INT,
  LONG,
  FLOAT,
  DOUBLE
 };

string Datatype_ToString(Datatype e);

