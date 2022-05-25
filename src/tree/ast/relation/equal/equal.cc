/**
 * @file equal.cc
 * @author Mohamed Hassanin
 * @brief AST node for equal rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "equal.hh"

Equal::Equal(string name) 
: Node(name)
{

}


void Equal::generate(std::ofstream& fd, std::vector<std::string>& stack) {
  Node::generate(fd, stack);
  fd << "EQ " << endl;
}