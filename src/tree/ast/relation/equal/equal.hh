/**
 * @file equal.hh
 * @author Mohamed Hassanin
 * @brief AST node for equal rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../../../tree/tree.hh"

using namespace std;

class Equal : public Node {

  public:
  Equal(string);
  virtual void generate(ofstream&);
};