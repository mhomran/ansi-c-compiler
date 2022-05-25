/**
 * @file lower_equal.hh
 * @author Mohamed Hassanin
 * @brief AST node for lower_equal rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../../binary_op/binary_op.hh"

using namespace std;

class LowerEqual : public BinaryOp {

  public:
  LowerEqual(string);
  virtual void generate(std::ofstream&, std::vector<std::string>&);
};