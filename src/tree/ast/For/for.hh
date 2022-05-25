/**
 * @file for.hh
 * @author Mohamed Hassanin
 * @brief A for node for for loop.
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

class For : public Node {
  public:
    For(string name);
    virtual void generate(std::ofstream&, std::vector<std::string>&);
};