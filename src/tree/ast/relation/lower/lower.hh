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

#include "../../../tree/tree.hh"

using namespace std;

class Lower : public Node {

  public:
  Lower(string);
  virtual void generate(std::ofstream&, std::vector<std::string>&);
};