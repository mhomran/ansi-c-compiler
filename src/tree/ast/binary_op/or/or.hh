/**
 * @file or.hh
 * @author Mohamed Hassanin
 * @brief AST node for or rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../../tree/tree.hh"

using namespace std;

class Or : public Node {
  public:
  Or(string name);
  virtual void generate(std::ofstream&);
};