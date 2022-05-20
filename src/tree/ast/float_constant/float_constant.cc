/**
 * @file float_constant.cc
 * @author Mohamed Hassanin
 * @brief AST node for float_constant rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "float_constant.hh"

FloatConstant::FloatConstant(string name) 
: Node(name)
{

}


void FloatConstant::generate(ofstream& fd) {
  fd << "PUSH " << Node::name << endl;
}