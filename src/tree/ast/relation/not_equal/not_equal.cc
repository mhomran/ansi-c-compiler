/**
 * @file not_equal.cc
 * @author Mohamed Hassanin
 * @brief AST node for not_equal rule
 * @version 0.1
 * @date 2022-05-13
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "not_equal.hh"

NotEqual::NotEqual(string name) 
: Node(name)
{

}


void NotEqual::generate(std::ofstream& fd, std::vector<std::string>& stack) {
  Node::generate(fd, stack);
  fd << "NEQ " << endl;
}