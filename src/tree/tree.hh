/**
 * @file tree.hh
 * @author Tree Data Structure for printing the parse tree
 * @brief 
 * @version 0.1
 * @date 2022-04-27
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include <vector>
#include <string>
#include <fstream>

class Node
{
	int id;

	static void PrintLabels(Node* root, std::ofstream& fd);
	protected:
	std::string name;
	std::vector<Node *>children;
	public:
		static int NodesCount;

		Node(std::string Name);
		virtual ~Node();
		Node* insert(Node* node);
		std::vector<Node *> getChildren();
		virtual void generate(std::ofstream&);

		static void PrintParseTree(Node * root, std::string fname);
		static void DeleteTree(Node* node);
};
