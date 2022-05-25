/**
 * @file bitwise_not.hh
 * @author Mohamed Hassanin
 * @brief AST node for bitwise_not rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../../tree/tree.hh"

using namespace std;

class BitwiseNot : public Node {
  public:
  BitwiseNot(string name);
  virtual void generate(std::ofstream&, std::vector<std::string>&);
};