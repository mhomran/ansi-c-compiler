/**
 * @file add.hh
 * @author Mohamed Hassanin
 * @brief AST node for add rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../../tree/tree.hh"

using namespace std;

class Add : public Node {
  public:
  Add(string name);
  virtual void generate(std::ofstream&);
};