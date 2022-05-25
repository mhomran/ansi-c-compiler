/**
 * @file bitwise_and.hh
 * @author Mohamed Hassanin
 * @brief AST node for bitwise_and rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../binary_op.hh"

using namespace std;

class BitwiseAnd : public BinaryOp {
  public:
  BitwiseAnd(string name);
  virtual void generate(std::ofstream&, std::vector<std::string>&);
};