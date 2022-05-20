/**
 * @file int_constant.cc
 * @author Mohamed Hassanin
 * @brief AST node for int_constant rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "int_constant.hh"

IntConstant::IntConstant(string name) 
: Node(name)
{

}


void IntConstant::generate(ofstream& fd) {
  fd << "PUSH " << Node::name << endl;
}