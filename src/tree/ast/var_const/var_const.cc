/**
 * @file var_const.cc
 * @author Mohamed Hassanin
 * @brief AST node for var_const rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "var_const.hh"

VarConst::VarConst(string Name, DatatypeNode* datatypeNd, bool isConst) 
: Node(Name)
, datatypeNd{datatypeNd} 
, isConst{isConst} {

}

DatatypeNode* VarConst::getDatatypeNd() {
  return datatypeNd;
}

bool VarConst::getIsConst() {
  return isConst;  
}

VarConst::~VarConst() {
  delete datatypeNd;
}