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

#include <iostream>
#include <fstream>
#include "table.hh"
using namespace std;

SymbolTable::SymbolTable(std::ofstream& fd)
: prev{NULL}
, level{currLevel}
, wr_fd{fd} {
  currLevel++;
}

SymbolTable::SymbolTable(SymbolTable* prev, std::ofstream& fd) 
: prev{prev}
, level{currLevel}
, wr_fd{fd} {
  currLevel++;
}

SymbolTable::~SymbolTable() {
  currLevel--;
  for(auto symbol : symbols) {
    Symbol* sym = symbol.second;
    string symName = symbol.first;
    VarSymbol* temp = dynamic_cast<VarSymbol*>(sym);
    if(NULL != temp && !(temp->getIsUsed())) {
      wr_fd << "[WARNING]: @ line " << sym->getLine() << " " 
      << symName << " is Unsed." << endl;
      cout << "[WARNING]: @ line " << sym->getLine() << " " 
      << symName << " is Unsed." << endl;
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