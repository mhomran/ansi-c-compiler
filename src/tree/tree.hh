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
	std::vector<Node *>children;
	std::string name;
	int id;

	static void PrintLabels(Node* root, std::ofstream& fd);

	public:
		static int NodesCount;

		Node(std::string Name);
		virtual ~Node();
		Node* insert(Node* node);
		std::vector<Node *> getChildren();
		virtual void PrintNodeName(void);

		static void PrintParseTree(Node * root, std::string fname);
		static void DeleteTree(Node* node);
};
