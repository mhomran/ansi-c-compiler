/**
 * @file binary_op.hh
 * @author Mohamed Hassanin
 * @brief AST node for binary_op rules
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../../tree/tree.hh"

using namespace std;

class BinaryOp : public Node {
  public:
  BinaryOp(string name);
  virtual void generate(std::ofstream&, std::vector<std::string>&);
};