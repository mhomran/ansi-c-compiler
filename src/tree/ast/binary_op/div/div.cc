/**
 * @file div.cc
 * @author Mohamed Hassanin
 * @brief AST node for div rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "div.hh"

Div::Div(string name) : Node(name) {

}
void Div::generate(std::ofstream& fd) {
  Node::generate(fd);
  fd << "DIV" << endl;
}
