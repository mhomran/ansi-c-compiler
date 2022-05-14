/**
 * @file mul.hh
 * @author Mohamed Hassanin
 * @brief AST node for mul rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../../tree/tree.hh"

using namespace std;

class Mul : public Node {
  public:
  Mul(string name);
  virtual void generate(std::ofstream&);
};