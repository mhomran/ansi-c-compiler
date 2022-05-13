/**
 * @file table.cc
 * @author Mohamed Hassanin
 * @brief Symbol table data structure.
 * @version 0.1
 * @date 2022-05-12
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "table.hh"

SymbolTable::SymbolTable()
: prev{NULL}
, level{currLevel} {
  currLevel++;
}

SymbolTable::SymbolTable(SymbolTable* prev) 
: prev{prev}
, level{currLevel} {
  currLevel++;
}

SymbolTable::~SymbolTable() {
  currLevel++;
  for(auto symbol : symbols) {
    delete symbol.second;
  }
}

Symbol* SymbolTable::LookUp(string name) {
  Symbol* res = NULL;
  SymbolTable* table = this;

  do {
    if (symbols.find(name) != symbols.end()) {
      res = symbols.find(name)->second;
      break;
    }
    table = table->prev;
  } while(NULL != table);

  return res;
}

void SymbolTable::insert(string name, Symbol* sym) {
  symbols.insert(pair<string, Symbol*>(name, sym));

}

int SymbolTable::currLevel = 0;