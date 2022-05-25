/**
 * @file case.hh
 * @author Mohamed Hassanin
 * @brief AST node for the case rule.
 * @version 0.1
 * @date 2022-05-21
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include <iostream>
#include "../../tree.hh"
using namespace std;

class Case : public Node {
  public:
  Case(string name);
  virtual void generate(std::ofstream&, std::vector<std::string>&);
};