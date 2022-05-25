/**
 * @file declaration.hh
 * @author Mohamed Hassanin
 * @brief AST node for declaration rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../var_const/var_const.hh"

using namespace std;

class Declaration : public Node {
  VarConst* varConst;
  string identifier;
  bool isAssigned;

  public:
  Declaration(string, VarConst*, string, bool isAssigned = false);
  virtual void generate(std::ofstream&, std::vector<std::string>&);
};