/**
@file: parser.y
@brief: A parser for ANSI C language
@author: Mohamed Hassanin
*/

/* ------------------------------------------------------------------------- */
/* --------------------------- YACC Definitions ---------------------------- */
/* ------------------------------------------------------------------------- */

/* ------------------------- Tokens Definitions ---------------------------- */
// Variables and Constants declaration
%token IDENTIFIER CONSTANT STRING_LITERAL

// unary operators
%token INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP 

// Assignment statements
%token MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token XOR_ASSIGN OR_ASSIGN

// Data types
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOID

// If-then-else statement, while loops, repeat-until loops,
// for loops, switch statement
%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR CONTINUE BREAK RETURN
/* ------------------------------------------------------------------------- */

//start symbol
%start program

%{
/* ------------------------------- includes -------------------------------- */
#include <iostream>
#include "../tree/tree.h"
/* ------------------------------------------------------------------------- */

/* -------------------------- global variables ----------------------------- */
static Node* gParseTree;
/* ------------------------------------------------------------------------- */

/* ----------------------- extern global variables ------------------------- */
extern int column;
extern int line;
/* ------------------------------------------------------------------------- */

/* ------------------------- Functions prototypes -------------------------- */
int yylex(void);
void yyerror (char const *s);

Node* getParseTree ();
/* ------------------------------------------------------------------------- */
%}
/* ------------------------- Type Declarations ----------------------------- */
%union {
	struct {
		char name[50];
		struct Node* nd;
	} TreeNode;
}

%type <TreeNode> primary_expression postfix_expression argument_expression_list
%type <TreeNode> unary_expression unary_operator cast_expression
%type <TreeNode> multiplicative_expression additive_expression shift_expression
%type <TreeNode> relational_expression equality_expression and_expression
%type <TreeNode> exclusive_or_expression inclusive_or_expression logical_and_expression
%type <TreeNode> logical_or_expression conditional_expression assignment_expression
%type <TreeNode> assignment_operator expression constant_expression
%type <TreeNode> declaration declaration_specifiers init_declarator_list
%type <TreeNode> type_specifier specifier_qualifier_list type_qualifier
%type <TreeNode> declarator direct_declarator parameter_type_list
%type <TreeNode> parameter_list parameter_declaration identifier_list
%type <TreeNode> type_name abstract_declarator direct_abstract_declarator
%type <TreeNode> initializer initializer_list statement init_declarator
%type <TreeNode> labeled_statement compound_statement declaration_list
%type <TreeNode> statement_list expression_statement selection_statement
%type <TreeNode> iteration_statement jump_statement translation_unit
%type <TreeNode> external_declaration function_definition 

/* ------------------------------------------------------------------------- */
/* ------------------------------------------------------------------------- */
/* ------------------------- END YACC Definitions -------------------------- */
/* ------------------------------------------------------------------------- */
%%
/* ------------------------------------------------------------------------- */
/* ------------------------------- YACC Rules ------------------------------ */
/* ------------------------------------------------------------------------- */


/* Precedence decreases as you go down */
primary_expression
	: IDENTIFIER { $$.nd = new Node($$.name); }
	| CONSTANT { $$.nd = new Node("constant"); }
	| STRING_LITERAL { $$.nd = new Node("string literal"); }
	| '(' expression ')' {
		$$.nd = new Node("(");
		$$.nd->insert($2.nd)->insert(new Node(")"));
	}
	;

postfix_expression
	: primary_expression { 
		$$.nd = new Node("postfix_expression"); 
		$$.nd->insert($1.nd);
	}
	| postfix_expression '[' expression ']' {
		$$.nd = new Node("postfix_expression"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("["));
		$$.nd->insert($3.nd);
		$$.nd->insert(new Node("]"));
	}
	| postfix_expression '(' ')' {
		$$.nd = new Node("postfix_expression"); 
		$$.nd->insert(new Node("("));
		$$.nd->insert(new Node(")"));
	}
	| postfix_expression '(' argument_expression_list ')' {
		$$.nd = new Node("postfix_expression"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("("));
		$$.nd->insert($3.nd);
		$$.nd->insert(new Node(")"));
	}
	| postfix_expression INC_OP {
		$$.nd = new Node("postfix_expression"); 
		$$.nd->insert($1.nd)->insert(new Node("++"));
	}
	| postfix_expression DEC_OP {
		$$.nd = new Node("postfix_expression"); 
		$$.nd->insert($1.nd)->insert(new Node("--"));
	}
	;

argument_expression_list
	: assignment_expression {
		$$.nd = new Node ("argument_expression_list");
		$$.nd->insert($1.nd);
	}
	| argument_expression_list ',' assignment_expression {
		$$.nd = new Node ("argument_expression_list");
		$$.nd->insert($1.nd)->insert(new Node(","))->insert($3.nd);
	}
	;

unary_expression
	: postfix_expression {
		$$.nd = new Node ("argument_expression_list");
		$$.nd->insert($1.nd);
	}
	| INC_OP unary_expression {
		$$.nd = new Node ("argument_expression_list");
		$$.nd->insert(new Node("++"))->insert($2.nd);
	}
	| DEC_OP unary_expression {
		$$.nd = new Node ("argument_expression_list");
		$$.nd->insert(new Node("--"))->insert($2.nd);
	}
	| unary_operator cast_expression {
		$$.nd = new Node ("argument_expression_list");
		$$.nd->insert($1.nd)->insert($2.nd);
	}
	;

unary_operator
	: '&' { $$.nd = new Node("unary_operator"); $$.nd->insert(new Node("&")); }
	| '*' { $$.nd = new Node("unary_operator"); $$.nd->insert(new Node("*")); }
	| '+' { $$.nd = new Node("unary_operator"); $$.nd->insert(new Node("+")); }
	| '-' { $$.nd = new Node("unary_operator"); $$.nd->insert(new Node("-")); }
	| '~' { $$.nd = new Node("unary_operator"); $$.nd->insert(new Node("~")); }
	| '!' { $$.nd = new Node("unary_operator"); $$.nd->insert(new Node("!")); }
	;

cast_expression
	: unary_expression { $$.nd = new Node("cast_expression"); $$.nd->insert($1.nd); }
	| '(' type_name ')' cast_expression { 
		$$.nd = new Node("cast_expression"); 
		$$.nd->insert(new Node("(")); 
		$$.nd->insert($2.nd); 
		$$.nd->insert(new Node(")")); 
		$$.nd->insert($4.nd); 
	}
	;

multiplicative_expression 
	: cast_expression { $$.nd = new Node("multiplicative_expression"); $$.nd->insert($1.nd); }
	| multiplicative_expression '*' cast_expression {
		$$.nd = new Node("multiplicative_expression"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("*"));
		$$.nd->insert($3.nd);
	}
	| multiplicative_expression '/' cast_expression {
		$$.nd = new Node("multiplicative_expression"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("/"));
		$$.nd->insert($3.nd);
	}
	| multiplicative_expression '%' cast_expression {
		$$.nd = new Node("multiplicative_expression"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("%"));
		$$.nd->insert($3.nd);
	}
	;

additive_expression
	: multiplicative_expression { $$.nd = new Node("additive_expression"); $$.nd->insert($1.nd); }
	| additive_expression '+' multiplicative_expression {
		$$.nd = new Node("additive_expression"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("+"));
		$$.nd->insert($3.nd);
	}
	| additive_expression '-' multiplicative_expression {
		$$.nd = new Node("additive_expression"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("-"));
		$$.nd->insert($3.nd);
	}
	;

shift_expression
	: additive_expression { $$.nd = new Node("shift_expression"); $$.nd->insert($1.nd); }
	| shift_expression LEFT_OP additive_expression {
		$$.nd = new Node("shift_expression"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("<<"));
		$$.nd->insert($3.nd);		
	}
	| shift_expression RIGHT_OP additive_expression {
		$$.nd = new Node("shift_expression"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node(">>"));
		$$.nd->insert($3.nd);			
	}
	;

relational_expression
	: shift_expression { $$.nd = new Node("relational_expression"); $$.nd->insert($1.nd); }
	| relational_expression '<' shift_expression {
		$$.nd = new Node("relational_expression"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("<"));
		$$.nd->insert($3.nd);	
	}
	| relational_expression '>' shift_expression {
		$$.nd = new Node("relational_expression"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node(">"));
		$$.nd->insert($3.nd);		
	}
	| relational_expression LE_OP shift_expression {
		$$.nd = new Node("relational_expression"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("<="));
		$$.nd->insert($3.nd);
	}
	| relational_expression GE_OP shift_expression {
		$$.nd = new Node("relational_expression"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node(">="));
		$$.nd->insert($3.nd);
	}
	;

equality_expression
	: relational_expression { $$.nd = new Node("equality_expression"); $$.nd->insert($1.nd); }
	| equality_expression EQ_OP relational_expression {
		$$.nd = new Node("equality_expression"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("=="));
		$$.nd->insert($3.nd);		
	}
	| equality_expression NE_OP relational_expression {
		$$.nd = new Node("equality_expression"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("!="));
		$$.nd->insert($3.nd);		
	}
	;

and_expression
	: equality_expression { $$.nd = new Node("and_expression"); $$.nd->insert($1.nd); }
	| and_expression '&' equality_expression {
		$$.nd = new Node("and_expression"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("$"));
		$$.nd->insert($3.nd);			
	}
	;

exclusive_or_expression
	: and_expression { $$.nd = new Node("exclusive_or_expression"); $$.nd->insert($1.nd); }
	| exclusive_or_expression '^' and_expression {
		$$.nd = new Node("exclusive_or_expression"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("^"));
		$$.nd->insert($3.nd);			
	}
	;

inclusive_or_expression
	: exclusive_or_expression { $$.nd = new Node("inclusive_or_expression"); $$.nd->insert($1.nd); }
	| inclusive_or_expression '|' exclusive_or_expression {
		$$.nd = new Node("inclusive_or_expression"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("|"));
		$$.nd->insert($3.nd);			
	}
	;

logical_and_expression
	: inclusive_or_expression { $$.nd = new Node("logical_and_expression"); $$.nd->insert($1.nd); }
	| logical_and_expression AND_OP inclusive_or_expression {
		$$.nd = new Node("logical_and_expression"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("&&"));
		$$.nd->insert($3.nd);			
	}
	;

logical_or_expression
	: logical_and_expression { $$.nd = new Node("logical_or_expression"); $$.nd->insert($1.nd); }
	| logical_or_expression OR_OP logical_and_expression {
		$$.nd = new Node("logical_or_expression"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("||"));
		$$.nd->insert($3.nd);
	}
	;

conditional_expression
	: logical_or_expression { $$.nd = new Node("conditional_expression"); $$.nd->insert($1.nd); }
	| logical_or_expression '?' expression ':' conditional_expression
	;

assignment_expression
	: conditional_expression { $$.nd = new Node("assignment_expression"); $$.nd->insert($1.nd); }
	| unary_expression assignment_operator assignment_expression {
		$$.nd = new Node("logical_or_expression"); 
		$$.nd->insert($1.nd)->insert($2.nd)->insert($3.nd);
	}
	;

assignment_operator
	: '=' { $$.nd = new Node("assignment_expression"); $$.nd->insert(new Node("=")); }
	| MUL_ASSIGN { $$.nd = new Node("assignment_expression"); $$.nd->insert(new Node("*=")); }
	| DIV_ASSIGN { $$.nd = new Node("assignment_expression"); $$.nd->insert(new Node("/=")); }
	| MOD_ASSIGN { $$.nd = new Node("assignment_expression"); $$.nd->insert(new Node("%=")); }
	| ADD_ASSIGN { $$.nd = new Node("assignment_expression"); $$.nd->insert(new Node("+=")); }
	| SUB_ASSIGN { $$.nd = new Node("assignment_expression"); $$.nd->insert(new Node("-=")); }
	| LEFT_ASSIGN { $$.nd = new Node("assignment_expression"); $$.nd->insert(new Node("<<=")); }
	| RIGHT_ASSIGN { $$.nd = new Node("assignment_expression"); $$.nd->insert(new Node(">>=")); }
	| AND_ASSIGN { $$.nd = new Node("assignment_expression"); $$.nd->insert(new Node("&=")); }
	| XOR_ASSIGN { $$.nd = new Node("assignment_expression"); $$.nd->insert(new Node("^=")); }
	| OR_ASSIGN { $$.nd = new Node("assignment_expression"); $$.nd->insert(new Node("|=")); }
	;

expression
	: assignment_expression { $$.nd = new Node("expression"); $$.nd->insert($1.nd); }
	| expression ',' assignment_expression {
		$$.nd = new Node("expression");
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node(","));
		$$.nd->insert($3.nd);
	}
	;

constant_expression
	: conditional_expression { $$.nd = new Node("constant_expression"); $$.nd->insert($1.nd); }
	;

declaration
	: declaration_specifiers ';' {
		$$.nd = new Node("declaration");
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node(";"));
	}
	| declaration_specifiers init_declarator_list ';' {
		$$.nd = new Node("declaration");
		$$.nd->insert($1.nd);
		$$.nd->insert($2.nd);
		$$.nd->insert(new Node(";"));
	}
	;

declaration_specifiers
	: type_specifier {
		$$.nd = new Node("type_specifier");
		$$.nd->insert($1.nd);
	}
	| type_specifier declaration_specifiers {
		$$.nd = new Node("type_specifier");
		$$.nd->insert($1.nd);
		$$.nd->insert($2.nd);
	}
	| type_qualifier {
		$$.nd = new Node("type_specifier");
		$$.nd->insert($1.nd);
	}
	| type_qualifier declaration_specifiers {
		$$.nd = new Node("type_specifier");
		$$.nd->insert($1.nd);
		$$.nd->insert($2.nd);
	}
	;

init_declarator_list
	: init_declarator { $$.nd = new Node("init_declarator_list"); $$.nd->insert($1.nd); }
	| init_declarator_list ',' init_declarator {
		$$.nd = new Node("init_declarator_list");
		$$.nd->insert($1.nd)->insert(new Node(","))->insert($3.nd);
	}
	;

init_declarator
	: declarator { $$.nd = new Node("init_declarator"); $$.nd->insert($1.nd); }
	| declarator '=' initializer {
		$$.nd = new Node("init_declarator");
		$$.nd->insert($1.nd)->insert(new Node("="))->insert($3.nd);		
	}
	;

type_specifier
	: VOID { $$.nd = new Node("type_specifier"); $$.nd->insert(new Node("void")); }
	| CHAR { $$.nd = new Node("type_specifier"); $$.nd->insert(new Node("char")); }
	| SHORT { $$.nd = new Node("type_specifier"); $$.nd->insert(new Node("short")); }
	| INT { $$.nd = new Node("type_specifier"); $$.nd->insert(new Node("int")); }
	| LONG { $$.nd = new Node("type_specifier"); $$.nd->insert(new Node("long")); }
	| FLOAT { $$.nd = new Node("type_specifier"); $$.nd->insert(new Node("float")); }
	| DOUBLE { $$.nd = new Node("type_specifier"); $$.nd->insert(new Node("double")); }
	| SIGNED { $$.nd = new Node("type_specifier"); $$.nd->insert(new Node("signed")); }
	| UNSIGNED { $$.nd = new Node("type_specifier"); $$.nd->insert(new Node("unsigned")); }
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list {
		$$.nd = new Node("specifier_qualifier_list"); 
		$$.nd->insert($1.nd)->insert($2.nd); 		
	}
	| type_specifier { 
		$$.nd = new Node("specifier_qualifier_list"); 
		$$.nd->insert($1.nd); 
	}
	| type_qualifier specifier_qualifier_list {
		$$.nd = new Node("specifier_qualifier_list"); 
		$$.nd->insert($1.nd)->insert($2.nd); 		
	}
	| type_qualifier {
		$$.nd = new Node("specifier_qualifier_list"); 
		$$.nd->insert($1.nd); 		
	}
	;

type_qualifier
	: CONST	{
		$$.nd = new Node("type_qualifier"); 
		$$.nd->insert(new Node("const")); 		
	}
	;

declarator
	: direct_declarator {
		$$.nd = new Node("declarator");
		$$.nd->insert($1.nd);
	}
	;

direct_declarator
	: IDENTIFIER { $$.nd = new Node("direct_declarator"); $$.nd->insert(new Node($$.name));}
	| '(' declarator ')' {
		$$.nd = new Node("direct_declarator"); 
		$$.nd->insert(new Node("("));
		$$.nd->insert($2.nd);
		$$.nd->insert(new Node(")"));
	}
	| direct_declarator '[' constant_expression ']' {
		$$.nd = new Node("direct_declarator"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("(]"));
		$$.nd->insert($3.nd);
		$$.nd->insert(new Node("["));		
	}
	| direct_declarator '[' ']' {
		$$.nd = new Node("direct_declarator"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("["));
		$$.nd->insert(new Node("]"));		
	}
	| direct_declarator '(' parameter_type_list ')' {
		$$.nd = new Node("direct_declarator"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("("));
		$$.nd->insert($3.nd);
		$$.nd->insert(new Node(")"));		
	}
	| direct_declarator '(' identifier_list ')' {
		$$.nd = new Node("direct_declarator"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("("));
		$$.nd->insert($3.nd);
		$$.nd->insert(new Node(")"));		
	}
	| direct_declarator '(' ')' {
		$$.nd = new Node("direct_declarator"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("("));
		$$.nd->insert(new Node(")"));		
	}
	;

parameter_type_list
	: parameter_list { $$.nd = new Node("parameter_type_list"); $$.nd->insert($1.nd); }
	;

parameter_list
	: parameter_declaration { $$.nd = new Node("parameter_list"); $$.nd->insert($1.nd); }
	| parameter_list ',' parameter_declaration {
		$$.nd = new Node("parameter_list"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node(","));
		$$.nd->insert($3.nd);
	}
	;

parameter_declaration
	: declaration_specifiers declarator {
		$$.nd = new Node("parameter_declaration");
		$$.nd->insert($1.nd)->insert($2.nd);		
	}
	| declaration_specifiers abstract_declarator {
		$$.nd = new Node("parameter_declaration");
		$$.nd->insert($1.nd)->insert($2.nd);			
	}
	| declaration_specifiers { $$.nd = new Node("parameter_declaration"); $$.nd->insert($1.nd); }
	;

identifier_list
	: IDENTIFIER { $$.nd = new Node("identifier_list"); $$.nd->insert(new Node($$.name)); }
	| identifier_list ',' IDENTIFIER {
		$$.nd = new Node("identifier_list");
		$$.nd->insert($1.nd);		
		$$.nd->insert(new Node(","));
		$$.nd->insert(new Node($$.name));		
	}
	;

type_name
	: specifier_qualifier_list
	| specifier_qualifier_list abstract_declarator
	;

abstract_declarator
	: direct_abstract_declarator
	;

direct_abstract_declarator
	: '(' abstract_declarator ')' {
		$$.nd = new Node("direct_abstract_declarator");
		$$.nd->insert(new Node("("));
		$$.nd->insert($2.nd);		
		$$.nd->insert(new Node(")"));		
	}
	| '[' ']' {
		$$.nd = new Node("direct_abstract_declarator");
		$$.nd->insert(new Node("["));
		$$.nd->insert(new Node("]"));		
	}
	| '[' constant_expression ']' {
		$$.nd = new Node("direct_abstract_declarator");
		$$.nd->insert(new Node("["));
		$$.nd->insert($2.nd);		
		$$.nd->insert(new Node("]"));		
	}
	| direct_abstract_declarator '[' ']' {
		$$.nd = new Node("direct_abstract_declarator");
		$$.nd->insert($1.nd);		
		$$.nd->insert(new Node("["));
		$$.nd->insert(new Node("]"));		
	}
	| direct_abstract_declarator '[' constant_expression ']' {
		$$.nd = new Node("direct_abstract_declarator");
		$$.nd->insert($1.nd);		
		$$.nd->insert(new Node("["));
		$$.nd->insert($3.nd);		
		$$.nd->insert(new Node("]"));		
	}
	| '(' ')' {
		$$.nd = new Node("direct_abstract_declarator");
		$$.nd->insert(new Node("("));
		$$.nd->insert(new Node(")"));
	}
	| '(' parameter_type_list ')' {
		$$.nd = new Node("direct_abstract_declarator");
		$$.nd->insert(new Node("("));
		$$.nd->insert($2.nd);		
		$$.nd->insert(new Node(")"));		
	}
	| direct_abstract_declarator '(' ')' {
		$$.nd = new Node("direct_abstract_declarator");
		$$.nd->insert($1.nd);		
		$$.nd->insert(new Node("("));
		$$.nd->insert(new Node(")"));		
	}
	| direct_abstract_declarator '(' parameter_type_list ')' {
		$$.nd = new Node("direct_abstract_declarator");
		$$.nd->insert($1.nd);		
		$$.nd->insert(new Node("("));
		$$.nd->insert($3.nd);		
		$$.nd->insert(new Node(")"));		
	}
	;

initializer
	: assignment_expression { $$.nd = new Node("initializer"); $$.nd->insert($1.nd);}
	| '{' initializer_list '}' {
		$$.nd = new Node("initializer");
		$$.nd->insert(new Node("{"));
		$$.nd->insert($2.nd);		
		$$.nd->insert(new Node("}"));
	}
	| '{' initializer_list ',' '}' {
		$$.nd = new Node("initializer");
		$$.nd->insert(new Node("{"));
		$$.nd->insert($2.nd);		
		$$.nd->insert(new Node(","));		
		$$.nd->insert(new Node("}"));		
	}
	;

initializer_list
	: initializer { $$.nd = new Node("initializer_list"); $$.nd->insert($1.nd);}
	| initializer_list ',' initializer {
		$$.nd = new Node("initializer_list");
		$$.nd->insert($1.nd)->insert(new Node(","))->insert($3.nd);
	}
	;

statement
	: labeled_statement { $$.nd = new Node("statement"); $$.nd->insert($1.nd);}
	| compound_statement { $$.nd = new Node("statement"); $$.nd->insert($1.nd);}
	| expression_statement { $$.nd = new Node("statement"); $$.nd->insert($1.nd);}
	| selection_statement { $$.nd = new Node("statement"); $$.nd->insert($1.nd);}
	| iteration_statement { $$.nd = new Node("statement"); $$.nd->insert($1.nd);}
	| jump_statement { $$.nd = new Node("statement"); $$.nd->insert($1.nd); }
	;

labeled_statement
	: IDENTIFIER ':' statement {
		$$.nd = new Node("labeled_statement"); 
		$$.nd->insert(new Node($$.name)); 
		$$.nd->insert(new Node(":")); 
		$$.nd->insert($3.nd); 
	}
	| CASE constant_expression ':' statement {
		$$.nd = new Node("labeled_statement"); 
		$$.nd->insert(new Node("case")); 
		$$.nd->insert($2.nd); 
		$$.nd->insert(new Node(":")); 
		$$.nd->insert($4.nd);
	}
	| DEFAULT ':' statement {
		$$.nd = new Node("labeled_statement"); 
		$$.nd->insert(new Node("default")); 
		$$.nd->insert(new Node(":")); 
		$$.nd->insert($3.nd); 
	}
	;

compound_statement
	: '{' '}' {
		$$.nd = new Node("compound_statement"); 
		$$.nd->insert(new Node("{")); 
		$$.nd->insert(new Node("}")); 
	}
	| '{' statement_list '}' {
		$$.nd = new Node("compound_statement"); 
		$$.nd->insert(new Node("{")); 
		$$.nd->insert($2.nd); 
		$$.nd->insert(new Node("}")); 		
	}
	| '{' declaration_list '}' {
		$$.nd = new Node("compound_statement"); 
		$$.nd->insert(new Node("{")); 
		$$.nd->insert($2.nd); 
		$$.nd->insert(new Node("}")); 		
	}
	| '{' declaration_list statement_list '}' {
		$$.nd = new Node("compound_statement"); 
		$$.nd->insert(new Node("{")); 
		$$.nd->insert($2.nd); 
		$$.nd->insert($3.nd); 
		$$.nd->insert(new Node("}")); 
	}
	;

declaration_list
	: declaration { $$.nd = new Node("declaration_list"); $$.nd->insert($1.nd); }
	| declaration_list declaration {
		$$.nd = new Node("declaration_list"); $$.nd->insert($1.nd)->insert($2.nd);
	}
	;

statement_list
	: statement { $$.nd = new Node("statement_list"); $$.nd->insert($1.nd); }
	| statement_list statement {
		$$.nd = new Node("statement_list"); $$.nd->insert($1.nd)->insert($2.nd);
	}
	;

expression_statement
	: ';' { 
		$$.nd = new Node("expression_statement"); 
		$$.nd->insert(new Node(";"));
	}
	| expression ';' {
		$$.nd = new Node("expression_statement"); 
		$$.nd->insert($1.nd)->insert(new Node(";"));
	}
	;

selection_statement
	: IF '(' expression ')' statement {
		$$.nd = new Node("selection_statement"); 
		$$.nd->insert(new Node("if"));
		$$.nd->insert(new Node("("));
		$$.nd->insert($3.nd);
		$$.nd->insert(new Node(")"));
		$$.nd->insert($5.nd);
	}
	| IF '(' expression ')' statement ELSE statement {
		$$.nd = new Node("selection_statement"); 
		$$.nd->insert(new Node("if"));
		$$.nd->insert(new Node("("));
		$$.nd->insert($3.nd);
		$$.nd->insert(new Node(")"));
		$$.nd->insert($5.nd);
		$$.nd->insert(new Node("else"));
		$$.nd->insert($7.nd);
	}
	| SWITCH '(' expression ')' statement {
		$$.nd = new Node("switch"); 
		$$.nd->insert(new Node("("));
		$$.nd->insert($3.nd);
		$$.nd->insert(new Node(")"));
		$$.nd->insert($5.nd);
	}
	;

iteration_statement
	: WHILE '(' expression ')' statement {
		$$.nd = new Node("iteration_statement"); 
		$$.nd->insert(new Node("while"));
		$$.nd->insert(new Node("("));
		$$.nd->insert($3.nd);
		$$.nd->insert(new Node(")"));
		$$.nd->insert($5.nd);
	}
	| DO statement WHILE '(' expression ')' ';' {
		$$.nd = new Node("iteration_statement"); 
		$$.nd->insert(new Node("do"));
		$$.nd->insert($2.nd);
		$$.nd->insert(new Node("while"));
		$$.nd->insert(new Node("("));
		$$.nd->insert($5.nd);
		$$.nd->insert(new Node(")"));
		$$.nd->insert(new Node(";"));
	}
	| FOR '(' expression_statement expression_statement ')' statement {
		$$.nd = new Node("iteration_statement"); 
		$$.nd->insert(new Node("for"));
		$$.nd->insert(new Node("("));
		$$.nd->insert($3.nd);
		$$.nd->insert($4.nd);
		$$.nd->insert(new Node(")"));
		$$.nd->insert($6.nd);
	}
	| FOR '(' expression_statement expression_statement expression ')' statement {
		$$.nd = new Node("iteration_statement"); 
		$$.nd->insert(new Node("for"));
		$$.nd->insert(new Node("("));
		$$.nd->insert($3.nd);
		$$.nd->insert($4.nd);
		$$.nd->insert($5.nd);		
		$$.nd->insert(new Node(")"));
		$$.nd->insert($7.nd);		
	}
	;

jump_statement
	: CONTINUE ';' {		
		$$.nd = new Node("jump_statement"); 
		$$.nd->insert(new Node("continue"))->insert(new Node(";"));
	}
	| BREAK ';' {
		$$.nd = new Node("jump_statement"); 
		$$.nd->insert(new Node("BREAK"))->insert(new Node(";"));
	}
	| RETURN ';' { 
		$$.nd = new Node("jump_statement"); 
		$$.nd->insert(new Node("return"))->insert(new Node(";")); 
	}
	| RETURN expression ';' { 
		$$.nd = new Node("jump_statement"); 
		$$.nd->insert(new Node("return"))->insert($2.nd)->insert(new Node(";")); 
	}
	;

program: translation_unit { gParseTree = $1.nd;}

translation_unit
	: external_declaration {
		$$.nd = new Node("translation_unit"); 
		$$.nd->insert($1.nd);
	}
	| translation_unit external_declaration {
		$$.nd = new Node("translation_unit"); 
		$$.nd->insert($1.nd)->insert($2.nd);
	}
	;

external_declaration
	: function_definition { 
		$$.nd = new Node("external_declaration"); 
		$$.nd->insert($1.nd);
	}
	| declaration { 
		$$.nd = new Node("external_declaration"); 
		$$.nd->insert($1.nd);
	}
	;

function_definition
	: declaration_specifiers declarator declaration_list compound_statement {
		$$.nd = new Node("function_definition"); 
		$$.nd->insert($1.nd)->insert($2.nd)->insert($3.nd)->insert($4.nd);
	}
	| declaration_specifiers declarator compound_statement {
		$$.nd = new Node("function_definition"); 
		$$.nd->insert($1.nd)->insert($2.nd)->insert($3.nd);
	}
	| declarator declaration_list compound_statement {
		$$.nd = new Node("function_definition"); 
		$$.nd->insert($1.nd)->insert($2.nd)->insert($3.nd);
	}
	| declarator compound_statement {
		$$.nd = new Node("function_definition"); 
		$$.nd->insert($1.nd)->insert($2.nd);
	}
	;


/* ------------------------------------------------------------------------- */
/* ----------------------------- END YACC Rules ---------------------------- */
/* ------------------------------------------------------------------------- */

%%
/* ------------------------------------------------------------------------- */
/* ------------------------------ subroutines ------------------------------ */
/* ------------------------------------------------------------------------- */

/* ------------------------- Functions Definitions ------------------------- */
void
yyerror (char const *s)
{
	fflush(stdout);
	printf("\n%*s\n%*s\n", column, "^", column, s);
	printf("line:%d\n", line);
}

Node* getParseTree ()
{
	return gParseTree;
}
/* ------------------------------------------------------------------------- */

/* ------------------------------------------------------------------------- */
/* ---------------------------- END subroutines ---------------------------- */
/* ------------------------------------------------------------------------- */

/* ------------------------------- END FILE ------------------------------- */
