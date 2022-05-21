/**
 * @file default.hh
 * @author Mohamed Hassanin
 * @brief AST node for the default rule.
 * @version 0.1
 * @date 2022-05-21
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include <iostream>
#include "../../tree.hh"
using namespace std;

class Default : public Node {
  public:
  Default(string name);
  virtual void generate(std::ofstream&);
};