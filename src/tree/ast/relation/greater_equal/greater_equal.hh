/**
 * @file greater_equal.hh
 * @author Mohamed Hassanin
 * @brief AST node for greater_equal rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../../../tree/tree.hh"

using namespace std;

class GreaterEqual : public Node {

  public:
  GreaterEqual(string);
  virtual void generate(ofstream&);
};