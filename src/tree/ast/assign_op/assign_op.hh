/**
 * @file assign_op.hh
 * @author Mohamed Hassanin
 * @brief AST node for assign_op.
 * @version 0.1
 * @date 2022-05-17
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../../tree/tree.hh"

using namespace std;

class AssignOp : public Node {
  public:
  AssignOp(string name);
  virtual void generate(ofstream&);
};