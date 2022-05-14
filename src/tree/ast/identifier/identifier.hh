/**
 * @file identifier.hh
 * @author Mohamed Hassanin
 * @brief AST node for identifier rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../../tree/tree.hh"

using namespace std;

class Identifier : public Node {

  public:
  Identifier(string);
  virtual void generate(ofstream&);
};