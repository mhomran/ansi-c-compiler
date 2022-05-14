/**
 * @file mod.cc
 * @author Mohamed Hassanin
 * @brief AST node for mod rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "mod.hh"

Mod::Mod(string name) : Node(name) {

}
void Mod::generate(std::ofstream& fd) {
  Node::generate(fd);
  fd << "MOD" << endl;
}
