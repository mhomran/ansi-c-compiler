/**
 * @file do_while.hh
 * @author Mohamed Hassanin
 * @brief A do_while node for do_while loop.
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

class DoWhile : public Node {
  public:
    DoWhile(string name);
    virtual void generate(std::ofstream&);
};