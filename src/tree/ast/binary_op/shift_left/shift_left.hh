/**
 * @file shift_left.hh
 * @author Mohamed Hassanin
 * @brief AST node for shift_left rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../../tree/tree.hh"

using namespace std;

class ShiftLeft : public Node {
  public:
  ShiftLeft(string name);
  virtual void generate(std::ofstream&);
};