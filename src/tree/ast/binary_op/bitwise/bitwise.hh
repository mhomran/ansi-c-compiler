/**
 * @file bitwise.hh
 * @author Mohamed Hassanin
 * @brief AST node for bitwise rules
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../binary_op.hh"

using namespace std;

class Bitwise : public BinaryOp {
  public:
  static void checkFloat(Node* root);
};