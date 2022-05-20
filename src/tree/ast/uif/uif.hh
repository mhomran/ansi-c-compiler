/**
 * @file uif.hh
 * @author Mohamed Hassanin
 * @brief AST node for Unmatched IF rule.
 * @version 0.1
 * @date 2022-05-20
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include <iostream>
#include "../../tree.hh"
using namespace std;

class Uif : public Node {
  public:
    Uif(string name);
    virtual void generate(std::ofstream&);
};
