/**
 * @file sub.hh
 * @author Mohamed Hassanin
 * @brief AST node for sub rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../../tree/tree.hh"

using namespace std;

class Sub : public Node {
  public:
  Sub(string name);
  virtual void generate(std::ofstream&);
};