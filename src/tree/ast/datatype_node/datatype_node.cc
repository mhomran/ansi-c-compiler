/**
 * @file datatype_node.cc
 * @author Mohamed Hassanin
 * @brief AST node for datatype rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "datatype_node.hh"

DatatypeNode::DatatypeNode(string Name, Datatype datatype) 
: Node(Name)
, datatype{datatype} {

}

Datatype DatatypeNode::getDatatype(void) {
  return datatype;
}