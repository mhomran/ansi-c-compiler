/**
 * @file while.hh
 * @author Mohamed Hassanin
 * @brief A while node for while loop.
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

class While : public Node {
  public:
    While(string name);
    virtual void generate(std::ofstream&);
};