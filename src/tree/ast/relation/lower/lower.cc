/**
 * @file lower.cc
 * @author Mohamed Hassanin
 * @brief AST node for lower rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "lower.hh"

Lower::Lower(string name) 
: Node(name)
{

}


void Lower::generate(std::ofstream& fd, std::vector<std::string>& stack) {
  Node::generate(fd, stack);
  fd << "LR " << endl;
}