/**
 * @file div.hh
 * @author Mohamed Hassanin
 * @brief AST node for div rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../../tree/tree.hh"

using namespace std;

class Div : public Node {
  public:
  Div(string name);
  virtual void generate(std::ofstream&);
};