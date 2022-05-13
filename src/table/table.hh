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
#include "../sym/var_sym/var_sym.hh"

using namespace std;

class SymbolTable {
  map<string, Symbol*> symbols;
  
  static int currLevel;
  SymbolTable* prev;
  int level;

  public:
    SymbolTable();
    SymbolTable(SymbolTable* prev);
    ~SymbolTable();
    
    Symbol* LookUp(string);
    void insert(string, Symbol*);

    SymbolTable* getPrev(void);
    int getLevel(void);
};