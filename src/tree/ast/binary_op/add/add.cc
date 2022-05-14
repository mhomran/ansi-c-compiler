/**
 * @file add.cc
 * @author Mohamed Hassanin
 * @brief AST node for add rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "add.hh"

Add::Add(string name) : Node(name) {

}
void Add::generate(std::ofstream& fd) {
  Node::generate(fd);
  fd << "ADD" << endl;
}
