/**
 * @file shift_left.cc
 * @author Mohamed Hassanin
 * @brief AST node for shift_left rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "shift_left.hh"

ShiftLeft::ShiftLeft(string name) : Node(name) {

}
void ShiftLeft::generate(std::ofstream& fd) {
  Node::generate(fd);
  fd << "SHIFT_LEFT" << endl;
}
