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

#include "../../binary_op/binary_op.hh"

using namespace std;

class Equal : public BinaryOp {

  public:
  Equal(string);
  virtual void generate(std::ofstream&, std::vector<std::string>&);
};