/**
 * @file bitwise.cc
 * @author Mohamed Hassanin
 * @brief AST node for bitwise rules
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include <iostream>
#include <sstream>

#include "bitwise.hh"
#include "../../float_constant/float_constant.hh"
#include "../../identifier/identifier.hh"
#include "../../../common/datatype.hh"

extern int line;

void Bitwise::checkFloat(Node* root) {
  if (NULL == root) return;

  std::ostringstream buffer;
  Identifier* id;

  id = dynamic_cast<Identifier*>(root);

  if(NULL != dynamic_cast<FloatConstant*>(root) ||
  (NULL != id && (id->getDatatype() == Datatype::FLOAT || 
  id->getDatatype() == Datatype::DOUBLE))){
    buffer << "[ERROR]: @ line " << line << " bitwise operation on a float: "
     << root->getName() << std::endl;

    throw buffer.str();
  } else {
    auto children = root->getChildren();
    for (size_t i=0; i < children.size(); i++){
      checkFloat(children[i]);
	  }
  }
}
