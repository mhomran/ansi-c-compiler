/**
 * @file declaration.cc
 * @author Mohamed Hassanin
 * @brief AST node for declaration rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "declaration.hh"

Declaration::Declaration(string name, VarConst* varConst, string identifier) 
: Node(name),
varConst{varConst},
identifier{identifier}
{

}
