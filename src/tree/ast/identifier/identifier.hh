/**
 * @file identifier.hh
 * @author Mohamed Hassanin
 * @brief AST node for identifier rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../../tree/tree.hh"
#include "../../../common/datatype.hh"

using namespace std;

class Identifier : public Node {
  Datatype dt;

  public:
  Identifier(string, Datatype);
  virtual void generate(std::ofstream&, std::vector<std::string>&);
  Datatype getDatatype();
};