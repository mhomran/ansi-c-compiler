/**
 * @file lower.hh
 * @author Mohamed Hassanin
 * @brief AST node for lower rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../../binary_op/binary_op.hh"

using namespace std;

class Lower : public BinaryOp {

  public:
  Lower(string);
  virtual void generate(std::ofstream&, std::vector<std::string>&);
};