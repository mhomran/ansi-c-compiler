/**
 * @file datatype_node.hh
 * @author Mohamed Hassanin
 * @brief AST node for datatype rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include "../../tree.hh"
#include "../../../common/datatype.hh"

using namespace std;

class DatatypeNode : public Node {
  Datatype datatype;

  public:
  DatatypeNode(string Name, Datatype Datatype);
  Datatype getDatatype(void);
};