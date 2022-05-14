/**
 * @file constant.hh
 * @author Mohamed Hassanin
 * @brief AST node for constant rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../../tree/tree.hh"

using namespace std;

class Constant : public Node {

  public:
  Constant(string);
  virtual void generate(ofstream&);
};