/**
 * @file mif.hh
 * @author Mohamed Hassanin
 * @brief AST node for Matched IF rule.
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

class Mif : public Node {
  public:
    Mif(string name);
    virtual void generate(std::ofstream&);
};
