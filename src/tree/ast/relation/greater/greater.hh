/**
 * @file greater.hh
 * @author Mohamed Hassanin
 * @brief AST node for greater rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../../../tree/tree.hh"

using namespace std;

class Greater : public Node {

  public:
  Greater(string);
  virtual void generate(ofstream&);
};