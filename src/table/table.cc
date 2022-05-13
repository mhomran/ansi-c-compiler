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
#include <iostream>
using namespace std;

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
    Symbol* sym = symbol.second;
    string symName = symbol.first;
    VarSymbol* temp = dynamic_cast<VarSymbol*>(sym);
    if(NULL != temp && !(temp->getIsUsed())) {
      cout << endl << "[WARNING]: " << symName << " is Unsed." << endl;
    }
    delete sym;
  }
}

Symbol* SymbolTable::LookUp(string name) {
  Symbol* res = NULL;
  SymbolTable* table = this;

  do {
    if (table->symbols.find(name) != table->symbols.end()) {
      res = table->symbols.find(name)->second;
      break;
    }
    table = table->prev;
  } while(NULL != table);

  return res;
}

void SymbolTable::insert(string name, Symbol* sym) {
  symbols.insert(pair<string, Symbol*>(name, sym));

}

SymbolTable* SymbolTable::getPrev(void) {
  return prev;
}

int SymbolTable::getLevel(void) {
  return level;
}

int SymbolTable::currLevel = 0;