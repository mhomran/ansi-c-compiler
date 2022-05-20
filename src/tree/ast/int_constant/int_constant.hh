/**
 * @file int_constant.hh
 * @author Mohamed Hassanin
 * @brief AST node for int_constant rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../../tree/tree.hh"

using namespace std;

class IntConstant : public Node {

  public:
  IntConstant(string);
  virtual void generate(ofstream&);
};