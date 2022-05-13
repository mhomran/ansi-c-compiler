/**
 * @file sym.hh
 * @author Mohamed Hassanin
 * @brief A data structure for the symbol in the symbol tables.
 * @version 0.1
 * @date 2022-05-12
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include <string>
using namespace std;

class Symbol {
  string name;
  int scope;
  int line;
  
  public:
  Symbol(string name, int scope, int line);
  virtual ~Symbol();
  virtual void print();
  int getScope();
  int getLine(void);
};