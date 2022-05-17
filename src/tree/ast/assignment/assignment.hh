/**
 * @file assignment.hh
 * @author Mohamed Hassanin
 * @brief AST node for assignment.
 * @version 0.1
 * @date 2022-05-17
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../../tree/tree.hh"

using namespace std;

class Assignment : public Node {
  string identifier;

  public:
  Assignment(string name, string);
  virtual void generate(ofstream&);
};