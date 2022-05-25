/**
 * @file bitwise_not.cc
 * @author Mohamed Hassanin
 * @brief AST node for bitwise_not rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "bitwise_not.hh"

BitwiseNot::BitwiseNot(string name) : Node(name) {

}
void BitwiseNot::generate(std::ofstream& fd, std::vector<std::string>& stack) {
  Node::generate(fd, stack);
  fd << "BITWISE_NOT" << endl;
}
