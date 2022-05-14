/**
 * @file bitwise_xor.hh
 * @author Mohamed Hassanin
 * @brief AST node for bitwise_xor rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../../tree/tree.hh"

using namespace std;

class BitwiseXor : public Node {
  public:
  BitwiseXor(string name);
  virtual void generate(std::ofstream&);
};