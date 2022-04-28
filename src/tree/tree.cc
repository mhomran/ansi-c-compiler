/**
 * @file tree.cc
 * @author Tree Data Structure for printing the parse tree
 * @brief 
 * @version 0.1
 * @date 2022-04-27
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include <bits/stdc++.h>
#include "tree.h"


Node::Node(std::string Name)
	: name{Name}
	, id{NodesCount} {
	NodesCount++;
}

void Node::PrintParseTree(Node * root) {
	if (root==NULL) return;

	std::ofstream fd;
	fd.open ("parse_tree.dot");
	fd << "digraph parser_tree {" << std::endl;
	
	PrintLabels(root, fd);

	std::queue<Node *> q; 
	q.push(root); 
	while (!q.empty())
	{
		int n = q.size();

		while (n > 0)
		{
			Node * p = q.front();
			q.pop();
			fd << p->id << "-> {";
			for (int i=0; i<p->children.size(); i++){
				if(p->children[i]) {
					q.push(p->children[i]);
					fd << p->children[i]->id << (i==p->children.size()-1 ? "" : ",");
				}
			}
			fd << "}"<< std::endl; // Print new line between two levels
			n--;
		}
	}

	fd << "}"<< std::endl; 
	fd.close();

	system("dot -Tpng -O parse_tree.dot");
}

Node* Node::insert(Node* node) {
	children.push_back(node);
	return this;
}

std::vector<Node *> Node::getChildren() {
	return children;
}

void Node::DeleteTree(Node* root)
{
	if (root == NULL) return;

	for (int i=0; i<root->children.size(); i++){
		DeleteTree(root->children[i]);
	}
	
	delete root;
}

void Node::PrintLabels(Node* root, std::ofstream& fd)
{
	if (root == NULL) return;
 
	/* first print data of node */
	fd << root->id << " [label=\"" << root->name << "\"]" << std::endl;

	for (int i=0; i<root->children.size(); i++){
		PrintLabels(root->children[i], fd);
	}
}

int Node::NodesCount = 0;
