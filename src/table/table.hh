/**
 * @file table.hh
 * @author Mohamed Hassanin
 * @brief Symbol table data structure.
 * @version 0.1
 * @date 2022-05-12
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include <map>
#include <string>
#include "../sym/sym.hh"

using namespace std;

class SymbolTable {
  SymbolTable* prev;
  int level;
  map<string, Symbol*> symbols;
  
  static int currLevel;

  public:
    SymbolTable();
    SymbolTable(SymbolTable* prev);
    ~SymbolTable();
    
    Symbol* LookUp(string);
    bool Insert(Symbol*);
};