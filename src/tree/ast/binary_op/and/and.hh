/**
 * @file and.hh
 * @author Mohamed Hassanin
 * @brief AST node for and rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../binary_op.hh"

using namespace std;

class And : public BinaryOp {
  public:
  And(string name);
  virtual void generate(std::ofstream&, std::vector<std::string>&);
};