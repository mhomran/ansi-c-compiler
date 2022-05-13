/**
 * @file var_const.hh
 * @author Mohamed Hassanin
 * @brief AST node for var_const rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../datatype_node/datatype_node.hh"

using namespace std;

class VarConst : public Node {
  DatatypeNode* datatypeNd;
  bool isConst;

  public:
  VarConst(string Name, DatatypeNode* datatypeNd, bool isConst);
};