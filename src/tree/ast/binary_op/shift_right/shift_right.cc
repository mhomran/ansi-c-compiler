/**
 * @file shift_right.cc
 * @author Mohamed Hassanin
 * @brief AST node for shift_right rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "shift_right.hh"

ShiftRight::ShiftRight(string name) : Node(name) {

}
void ShiftRight::generate(std::ofstream& fd) {
  Node::generate(fd);
  fd << "SHIFT_RIGHT" << endl;
}
