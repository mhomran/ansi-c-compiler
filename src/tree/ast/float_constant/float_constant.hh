/**
 * @file float_constant.hh
 * @author Mohamed Hassanin
 * @brief AST node for float_constant rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../../tree/tree.hh"

using namespace std;

class FloatConstant : public Node {

  public:
  FloatConstant(string);
  virtual void generate(ofstream&);
};