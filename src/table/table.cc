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

}

bool SymbolTable::Insert(Symbol* sym) {

}

int SymbolTable::currLevel = 0;