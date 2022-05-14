/**
 * @file not.cc
 * @author Mohamed Hassanin
 * @brief AST node for not rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "not.hh"

Not::Not(string name) : Node(name) {

}
void Not::generate(std::ofstream& fd) {
  Node::generate(fd);
  fd << "NOT" << endl;
}
