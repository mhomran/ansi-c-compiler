/**
 * @file not_equal.hh
 * @author Mohamed Hassanin
 * @brief AST node for not_equal rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../../../tree/tree.hh"

using namespace std;

class NotEqual : public Node {

  public:
  NotEqual(string);
  virtual void generate(std::ofstream&, std::vector<std::string>&);
};