/**
 * @file constant.cc
 * @author Mohamed Hassanin
 * @brief AST node for constant rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "constant.hh"

Constant::Constant(string name) 
: Node(name)
{

}


void Constant::generate(ofstream& fd) {
  fd << "PUSH " << Node::name << endl;
}