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
#include <stdio.h>
#include "../tree/tree.h"
/* ------------------------------------------------------------------------- */

/* -------------------------- global variables ----------------------------- */
static Node* gParseTree;
/* ------------------------------------------------------------------------- */

/* ----------------------- extern global variables ------------------------- */
extern int column;
extern int line;
extern char yytext[];
/* ------------------------------------------------------------------------- */

/* ------------------------- Functions prototypes -------------------------- */
int yylex(void);
void yyerror (char const *s);

Node* getParseTree ();
/* ------------------------------------------------------------------------- */
%}
/* ------------------------- Type Declarations ----------------------------- */
%union {
	struct Node* TreeNode;
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
	: IDENTIFIER { $$ = new Node("identifier"); }
	| CONSTANT { $$ = new Node("constant"); }
	| STRING_LITERAL { $$ = new Node("string literal"); }
	| '(' expression ')' {
		$$ = new Node("(");
		$$->insert($2)->insert(new Node(")"));
	}
	;

postfix_expression
	: primary_expression { 
		$$ = new Node("postfix_expression"); 
		$$->insert($1);
	}
	| postfix_expression '[' expression ']' {
		$$ = new Node("postfix_expression"); 
		$$->insert($1);
		$$->insert(new Node("["));
		$$->insert($3);
		$$->insert(new Node("]"));
	}
	| postfix_expression '(' ')' {
		$$ = new Node("postfix_expression"); 
		$$->insert(new Node("("));
		$$->insert(new Node(")"));
	}
	| postfix_expression '(' argument_expression_list ')' {
		$$ = new Node("postfix_expression"); 
		$$->insert($1);
		$$->insert(new Node("("));
		$$->insert($3);
		$$->insert(new Node(")"));
	}
	| postfix_expression INC_OP {
		$$ = new Node("postfix_expression"); 
		$$->insert($1)->insert(new Node("++"));
	}
	| postfix_expression DEC_OP {
		$$ = new Node("postfix_expression"); 
		$$->insert($1)->insert(new Node("--"));
	}
	;

argument_expression_list
	: assignment_expression {
		$$ = new Node ("argument_expression_list");
		$$->insert($1);
	}
	| argument_expression_list ',' assignment_expression {
		$$ = new Node ("argument_expression_list");
		$$->insert($1)->insert(new Node(","))->insert($3);
	}
	;

unary_expression
	: postfix_expression {
		$$ = new Node ("argument_expression_list");
		$$->insert($1);
	}
	| INC_OP unary_expression {
		$$ = new Node ("argument_expression_list");
		$$->insert(new Node("++"))->insert($2);
	}
	| DEC_OP unary_expression {
		$$ = new Node ("argument_expression_list");
		$$->insert(new Node("--"))->insert($2);
	}
	| unary_operator cast_expression {
		$$ = new Node ("argument_expression_list");
		$$->insert($1)->insert($2);
	}
	;

unary_operator
	: '&' { $$ = new Node("unary_operator"); $$->insert(new Node("&")); }
	| '*' { $$ = new Node("unary_operator"); $$->insert(new Node("*")); }
	| '+' { $$ = new Node("unary_operator"); $$->insert(new Node("+")); }
	| '-' { $$ = new Node("unary_operator"); $$->insert(new Node("-")); }
	| '~' { $$ = new Node("unary_operator"); $$->insert(new Node("~")); }
	| '!' { $$ = new Node("unary_operator"); $$->insert(new Node("!")); }
	;

cast_expression
	: unary_expression { $$ = new Node("cast_expression"); $$->insert($1); }
	| '(' type_name ')' cast_expression { 
		$$ = new Node("cast_expression"); 
		$$->insert(new Node("(")); 
		$$->insert($2); 
		$$->insert(new Node(")")); 
		$$->insert($4); 
	}
	;

multiplicative_expression 
	: cast_expression { $$ = new Node("multiplicative_expression"); $$->insert($1); }
	| multiplicative_expression '*' cast_expression {
		$$ = new Node("multiplicative_expression"); 
		$$->insert($1);
		$$->insert(new Node("*"));
		$$->insert($3);
	}
	| multiplicative_expression '/' cast_expression {
		$$ = new Node("multiplicative_expression"); 
		$$->insert($1);
		$$->insert(new Node("/"));
		$$->insert($3);
	}
	| multiplicative_expression '%' cast_expression {
		$$ = new Node("multiplicative_expression"); 
		$$->insert($1);
		$$->insert(new Node("%"));
		$$->insert($3);
	}
	;

additive_expression
	: multiplicative_expression { $$ = new Node("additive_expression"); $$->insert($1); }
	| additive_expression '+' multiplicative_expression {
		$$ = new Node("additive_expression"); 
		$$->insert($1);
		$$->insert(new Node("+"));
		$$->insert($3);
	}
	| additive_expression '-' multiplicative_expression {
		$$ = new Node("additive_expression"); 
		$$->insert($1);
		$$->insert(new Node("-"));
		$$->insert($3);
	}
	;

shift_expression
	: additive_expression { $$ = new Node("shift_expression"); $$->insert($1); }
	| shift_expression LEFT_OP additive_expression {
		$$ = new Node("shift_expression"); 
		$$->insert($1);
		$$->insert(new Node("<<"));
		$$->insert($3);		
	}
	| shift_expression RIGHT_OP additive_expression {
		$$ = new Node("shift_expression"); 
		$$->insert($1);
		$$->insert(new Node(">>"));
		$$->insert($3);			
	}
	;

relational_expression
	: shift_expression { $$ = new Node("relational_expression"); $$->insert($1); }
	| relational_expression '<' shift_expression {
		$$ = new Node("relational_expression"); 
		$$->insert($1);
		$$->insert(new Node("<"));
		$$->insert($3);	
	}
	| relational_expression '>' shift_expression {
		$$ = new Node("relational_expression"); 
		$$->insert($1);
		$$->insert(new Node(">"));
		$$->insert($3);		
	}
	| relational_expression LE_OP shift_expression {
		$$ = new Node("relational_expression"); 
		$$->insert($1);
		$$->insert(new Node("<="));
		$$->insert($3);
	}
	| relational_expression GE_OP shift_expression {
		$$ = new Node("relational_expression"); 
		$$->insert($1);
		$$->insert(new Node(">="));
		$$->insert($3);
	}
	;

equality_expression
	: relational_expression { $$ = new Node("equality_expression"); $$->insert($1); }
	| equality_expression EQ_OP relational_expression {
		$$ = new Node("equality_expression"); 
		$$->insert($1);
		$$->insert(new Node("=="));
		$$->insert($3);		
	}
	| equality_expression NE_OP relational_expression {
		$$ = new Node("equality_expression"); 
		$$->insert($1);
		$$->insert(new Node("!="));
		$$->insert($3);		
	}
	;

and_expression
	: equality_expression { $$ = new Node("and_expression"); $$->insert($1); }
	| and_expression '&' equality_expression {
		$$ = new Node("and_expression"); 
		$$->insert($1);
		$$->insert(new Node("$"));
		$$->insert($3);			
	}
	;

exclusive_or_expression
	: and_expression { $$ = new Node("exclusive_or_expression"); $$->insert($1); }
	| exclusive_or_expression '^' and_expression {
		$$ = new Node("exclusive_or_expression"); 
		$$->insert($1);
		$$->insert(new Node("^"));
		$$->insert($3);			
	}
	;

inclusive_or_expression
	: exclusive_or_expression { $$ = new Node("inclusive_or_expression"); $$->insert($1); }
	| inclusive_or_expression '|' exclusive_or_expression {
		$$ = new Node("inclusive_or_expression"); 
		$$->insert($1);
		$$->insert(new Node("|"));
		$$->insert($3);			
	}
	;

logical_and_expression
	: inclusive_or_expression { $$ = new Node("logical_and_expression"); $$->insert($1); }
	| logical_and_expression AND_OP inclusive_or_expression {
		$$ = new Node("logical_and_expression"); 
		$$->insert($1);
		$$->insert(new Node("&&"));
		$$->insert($3);			
	}
	;

logical_or_expression
	: logical_and_expression { $$ = new Node("logical_or_expression"); $$->insert($1); }
	| logical_or_expression OR_OP logical_and_expression {
		$$ = new Node("logical_or_expression"); 
		$$->insert($1);
		$$->insert(new Node("||"));
		$$->insert($3);
	}
	;

conditional_expression
	: logical_or_expression { $$ = new Node("conditional_expression"); $$->insert($1); }
	| logical_or_expression '?' expression ':' conditional_expression
	;

assignment_expression
	: conditional_expression { $$ = new Node("assignment_expression"); $$->insert($1); }
	| unary_expression assignment_operator assignment_expression {
		$$ = new Node("logical_or_expression"); 
		$$->insert($1)->insert($2)->insert($3);
	}
	;

assignment_operator
	: '=' { $$ = new Node("assignment_expression"); $$->insert(new Node("=")); }
	| MUL_ASSIGN { $$ = new Node("assignment_expression"); $$->insert(new Node("*=")); }
	| DIV_ASSIGN { $$ = new Node("assignment_expression"); $$->insert(new Node("/=")); }
	| MOD_ASSIGN { $$ = new Node("assignment_expression"); $$->insert(new Node("%=")); }
	| ADD_ASSIGN { $$ = new Node("assignment_expression"); $$->insert(new Node("+=")); }
	| SUB_ASSIGN { $$ = new Node("assignment_expression"); $$->insert(new Node("-=")); }
	| LEFT_ASSIGN { $$ = new Node("assignment_expression"); $$->insert(new Node("<<=")); }
	| RIGHT_ASSIGN { $$ = new Node("assignment_expression"); $$->insert(new Node(">>=")); }
	| AND_ASSIGN { $$ = new Node("assignment_expression"); $$->insert(new Node("&=")); }
	| XOR_ASSIGN { $$ = new Node("assignment_expression"); $$->insert(new Node("^=")); }
	| OR_ASSIGN { $$ = new Node("assignment_expression"); $$->insert(new Node("|=")); }
	;

expression
	: assignment_expression { $$ = new Node("expression"); $$->insert($1); }
	| expression ',' assignment_expression {
		$$ = new Node("expression");
		$$->insert($1);
		$$->insert(new Node(","));
		$$->insert($3);
	}
	;

constant_expression
	: conditional_expression { $$ = new Node("constant_expression"); $$->insert($1); }
	;

declaration
	: declaration_specifiers ';' {
		$$ = new Node("declaration");
		$$->insert($1);
		$$->insert(new Node(";"));
	}
	| declaration_specifiers init_declarator_list ';' {
		$$ = new Node("declaration");
		$$->insert($1);
		$$->insert($2);
		$$->insert(new Node(";"));
	}
	;

declaration_specifiers
	: type_specifier {
		$$ = new Node("type_specifier");
		$$->insert($1);
	}
	| type_specifier declaration_specifiers {
		$$ = new Node("type_specifier");
		$$->insert($1);
		$$->insert($2);
	}
	| type_qualifier {
		$$ = new Node("type_specifier");
		$$->insert($1);
	}
	| type_qualifier declaration_specifiers {
		$$ = new Node("type_specifier");
		$$->insert($1);
		$$->insert($2);
	}
	;

init_declarator_list
	: init_declarator { $$ = new Node("init_declarator_list"); $$->insert($1); }
	| init_declarator_list ',' init_declarator {
		$$ = new Node("init_declarator_list");
		$$->insert($1)->insert(new Node(","))->insert($3);
	}
	;

init_declarator
	: declarator { $$ = new Node("init_declarator"); $$->insert($1); }
	| declarator '=' initializer {
		$$ = new Node("init_declarator");
		$$->insert($1)->insert(new Node("="))->insert($3);		
	}
	;

type_specifier
	: VOID { $$ = new Node("type_specifier"); $$->insert(new Node("void")); }
	| CHAR { $$ = new Node("type_specifier"); $$->insert(new Node("char")); }
	| SHORT { $$ = new Node("type_specifier"); $$->insert(new Node("short")); }
	| INT { $$ = new Node("type_specifier"); $$->insert(new Node("int")); }
	| LONG { $$ = new Node("type_specifier"); $$->insert(new Node("long")); }
	| FLOAT { $$ = new Node("type_specifier"); $$->insert(new Node("float")); }
	| DOUBLE { $$ = new Node("type_specifier"); $$->insert(new Node("double")); }
	| SIGNED { $$ = new Node("type_specifier"); $$->insert(new Node("signed")); }
	| UNSIGNED { $$ = new Node("type_specifier"); $$->insert(new Node("unsigned")); }
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list {
		$$ = new Node("specifier_qualifier_list"); 
		$$->insert($1)->insert($2); 		
	}
	| type_specifier { 
		$$ = new Node("specifier_qualifier_list"); 
		$$->insert($1); 
	}
	| type_qualifier specifier_qualifier_list {
		$$ = new Node("specifier_qualifier_list"); 
		$$->insert($1)->insert($2); 		
	}
	| type_qualifier {
		$$ = new Node("specifier_qualifier_list"); 
		$$->insert($1); 		
	}
	;

type_qualifier
	: CONST	{
		$$ = new Node("type_qualifier"); 
		$$->insert(new Node("const")); 		
	}
	;

declarator
	: direct_declarator {
		$$ = new Node("declarator");
		$$->insert($1);
	}
	;

direct_declarator
	: IDENTIFIER { $$ = new Node("direct_declarator"); $$->insert(new Node("identifier")); }
	| '(' declarator ')' {
		$$ = new Node("direct_declarator"); 
		$$->insert(new Node("("));
		$$->insert($2);
		$$->insert(new Node(")"));
	}
	| direct_declarator '[' constant_expression ']' {
		$$ = new Node("direct_declarator"); 
		$$->insert($1);
		$$->insert(new Node("(]"));
		$$->insert($3);
		$$->insert(new Node("["));		
	}
	| direct_declarator '[' ']' {
		$$ = new Node("direct_declarator"); 
		$$->insert($1);
		$$->insert(new Node("["));
		$$->insert(new Node("]"));		
	}
	| direct_declarator '(' parameter_type_list ')' {
		$$ = new Node("direct_declarator"); 
		$$->insert($1);
		$$->insert(new Node("("));
		$$->insert($3);
		$$->insert(new Node(")"));		
	}
	| direct_declarator '(' identifier_list ')' {
		$$ = new Node("direct_declarator"); 
		$$->insert($1);
		$$->insert(new Node("("));
		$$->insert($3);
		$$->insert(new Node(")"));		
	}
	| direct_declarator '(' ')' {
		$$ = new Node("direct_declarator"); 
		$$->insert($1);
		$$->insert(new Node("("));
		$$->insert(new Node(")"));		
	}
	;

parameter_type_list
	: parameter_list { $$ = new Node("parameter_type_list"); $$->insert($1); }
	;

parameter_list
	: parameter_declaration { $$ = new Node("parameter_list"); $$->insert($1); }
	| parameter_list ',' parameter_declaration {
		$$ = new Node("parameter_list"); 
		$$->insert($1);
		$$->insert(new Node(","));
		$$->insert($3);
	}
	;

parameter_declaration
	: declaration_specifiers declarator {
		$$ = new Node("parameter_declaration");
		$$->insert($1)->insert($2);		
	}
	| declaration_specifiers abstract_declarator {
		$$ = new Node("parameter_declaration");
		$$->insert($1)->insert($2);			
	}
	| declaration_specifiers { $$ = new Node("parameter_declaration"); $$->insert($1); }
	;

identifier_list
	: IDENTIFIER { $$ = new Node("identifier_list"); $$->insert(new Node("identifier")); }
	| identifier_list ',' IDENTIFIER {
		$$ = new Node("identifier_list");
		$$->insert($1);		
		$$->insert(new Node(","));
		$$->insert(new Node("identifier"));		
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
		$$ = new Node("direct_abstract_declarator");
		$$->insert(new Node("("));
		$$->insert($2);		
		$$->insert(new Node(")"));		
	}
	| '[' ']' {
		$$ = new Node("direct_abstract_declarator");
		$$->insert(new Node("["));
		$$->insert(new Node("]"));		
	}
	| '[' constant_expression ']' {
		$$ = new Node("direct_abstract_declarator");
		$$->insert(new Node("["));
		$$->insert($2);		
		$$->insert(new Node("]"));		
	}
	| direct_abstract_declarator '[' ']' {
		$$ = new Node("direct_abstract_declarator");
		$$->insert($1);		
		$$->insert(new Node("["));
		$$->insert(new Node("]"));		
	}
	| direct_abstract_declarator '[' constant_expression ']' {
		$$ = new Node("direct_abstract_declarator");
		$$->insert($1);		
		$$->insert(new Node("["));
		$$->insert($3);		
		$$->insert(new Node("]"));		
	}
	| '(' ')' {
		$$ = new Node("direct_abstract_declarator");
		$$->insert(new Node("("));
		$$->insert(new Node(")"));
	}
	| '(' parameter_type_list ')' {
		$$ = new Node("direct_abstract_declarator");
		$$->insert(new Node("("));
		$$->insert($2);		
		$$->insert(new Node(")"));		
	}
	| direct_abstract_declarator '(' ')' {
		$$ = new Node("direct_abstract_declarator");
		$$->insert($1);		
		$$->insert(new Node("("));
		$$->insert(new Node(")"));		
	}
	| direct_abstract_declarator '(' parameter_type_list ')' {
		$$ = new Node("direct_abstract_declarator");
		$$->insert($1);		
		$$->insert(new Node("("));
		$$->insert($3);		
		$$->insert(new Node(")"));		
	}
	;

initializer
	: assignment_expression { $$ = new Node("initializer"); $$->insert($1);}
	| '{' initializer_list '}' {
		$$ = new Node("initializer");
		$$->insert(new Node("{"));
		$$->insert($2);		
		$$->insert(new Node("}"));
	}
	| '{' initializer_list ',' '}' {
		$$ = new Node("initializer");
		$$->insert(new Node("{"));
		$$->insert($2);		
		$$->insert(new Node(","));		
		$$->insert(new Node("}"));		
	}
	;

initializer_list
	: initializer { $$ = new Node("initializer_list"); $$->insert($1);}
	| initializer_list ',' initializer {
		$$ = new Node("initializer_list");
		$$->insert($1)->insert(new Node(","))->insert($3);
	}
	;

statement
	: labeled_statement { $$ = new Node("statement"); $$->insert($1);}
	| compound_statement { $$ = new Node("statement"); $$->insert($1);}
	| expression_statement { $$ = new Node("statement"); $$->insert($1);}
	| selection_statement { $$ = new Node("statement"); $$->insert($1);}
	| iteration_statement { $$ = new Node("statement"); $$->insert($1);}
	| jump_statement { $$ = new Node("statement"); $$->insert($1); }
	;

labeled_statement
	: IDENTIFIER ':' statement {
		$$ = new Node("labeled_statement"); 
		$$->insert(new Node("identifier")); 
		$$->insert(new Node(":")); 
		$$->insert($3); 
	}
	| CASE constant_expression ':' statement {
		$$ = new Node("labeled_statement"); 
		$$->insert(new Node("case")); 
		$$->insert($2); 
		$$->insert(new Node(":")); 
		$$->insert($4);
	}
	| DEFAULT ':' statement {
		$$ = new Node("labeled_statement"); 
		$$->insert(new Node("default")); 
		$$->insert(new Node(":")); 
		$$->insert($3); 
	}
	;

compound_statement
	: '{' '}' {
		$$ = new Node("compound_statement"); 
		$$->insert(new Node("{")); 
		$$->insert(new Node("}")); 
	}
	| '{' statement_list '}' {
		$$ = new Node("compound_statement"); 
		$$->insert(new Node("{")); 
		$$->insert($2); 
		$$->insert(new Node("}")); 		
	}
	| '{' declaration_list '}' {
		$$ = new Node("compound_statement"); 
		$$->insert(new Node("{")); 
		$$->insert($2); 
		$$->insert(new Node("}")); 		
	}
	| '{' declaration_list statement_list '}' {
		$$ = new Node("compound_statement"); 
		$$->insert(new Node("{")); 
		$$->insert($2); 
		$$->insert(new Node("}")); 
	}
	;

declaration_list
	: declaration { $$ = new Node("declaration_list"); $$->insert($1); }
	| declaration_list declaration {
		$$ = new Node("declaration_list"); $$->insert($1)->insert($2);
	}
	;

statement_list
	: statement { $$ = new Node("statement_list"); $$->insert($1); }
	| statement_list statement {
		$$ = new Node("statement_list"); $$->insert($1)->insert($2);
	}
	;

expression_statement
	: ';' { 
		$$ = new Node("expression_statement"); 
		$$->insert(new Node(";"));
	}
	| expression ';' {
		$$ = new Node("expression_statement"); 
		$$->insert($1)->insert(new Node(";"));
	}
	;

selection_statement
	: IF '(' expression ')' statement {
		$$ = new Node("selection_statement"); 
		$$->insert(new Node("if"));
		$$->insert(new Node("("));
		$$->insert($3);
		$$->insert(new Node(")"));
		$$->insert($5);
	}
	| IF '(' expression ')' statement ELSE statement {
		$$ = new Node("selection_statement"); 
		$$->insert(new Node("if"));
		$$->insert(new Node("("));
		$$->insert($3);
		$$->insert(new Node(")"));
		$$->insert($5);
		$$->insert(new Node("else"));
		$$->insert($7);
	}
	| SWITCH '(' expression ')' statement {
		$$ = new Node("switch"); 
		$$->insert(new Node("("));
		$$->insert($3);
		$$->insert(new Node(")"));
		$$->insert($5);
	}
	;

iteration_statement
	: WHILE '(' expression ')' statement {
		$$ = new Node("iteration_statement"); 
		$$->insert(new Node("while"));
		$$->insert(new Node("("));
		$$->insert($3);
		$$->insert(new Node(")"));
		$$->insert($5);
	}
	| DO statement WHILE '(' expression ')' ';' {
		$$ = new Node("iteration_statement"); 
		$$->insert(new Node("do"));
		$$->insert($2);
		$$->insert(new Node("while"));
		$$->insert(new Node("("));
		$$->insert($5);
		$$->insert(new Node(")"));
		$$->insert(new Node(";"));
	}
	| FOR '(' expression_statement expression_statement ')' statement {
		$$ = new Node("iteration_statement"); 
		$$->insert(new Node("for"));
		$$->insert(new Node("("));
		$$->insert($3);
		$$->insert($4);
		$$->insert(new Node(")"));
		$$->insert($6);
	}
	| FOR '(' expression_statement expression_statement expression ')' statement {
		$$ = new Node("iteration_statement"); 
		$$->insert(new Node("for"));
		$$->insert(new Node("("));
		$$->insert($3);
		$$->insert($4);
		$$->insert($5);		
		$$->insert(new Node(")"));
		$$->insert($7);		
	}
	;

jump_statement
	: CONTINUE ';' {		
		$$ = new Node("jump_statement"); 
		$$->insert(new Node("continue"))->insert(new Node(";"));
	}
	| BREAK ';' {
		$$ = new Node("jump_statement"); 
		$$->insert(new Node("BREAK"))->insert(new Node(";"));
	}
	| RETURN ';' { 
		$$ = new Node("jump_statement"); 
		$$->insert(new Node("return"))->insert(new Node(";")); 
	}
	| RETURN expression ';' { 
		$$ = new Node("jump_statement"); 
		$$->insert(new Node("return"))->insert($2)->insert(new Node(";")); 
	}
	;

program: translation_unit { gParseTree = $1;}

translation_unit
	: external_declaration {
		$$ = new Node("translation_unit"); 
		$$->insert($1);
	}
	| translation_unit external_declaration {
		$$ = new Node("translation_unit"); 
		$$->insert($1)->insert($2);
	}
	;

external_declaration
	: function_definition { 
		$$ = new Node("external_declaration"); 
		$$->insert($1);
	}
	| declaration { 
		$$ = new Node("external_declaration"); 
		$$->insert($1);
	}
	;

function_definition
	: declaration_specifiers declarator declaration_list compound_statement {
		$$ = new Node("function_definition"); 
		$$->insert($1)->insert($2)->insert($3)->insert($4);
	}
	| declaration_specifiers declarator compound_statement {
		$$ = new Node("function_definition"); 
		$$->insert($1)->insert($2)->insert($3);
	}
	| declarator declaration_list compound_statement {
		$$ = new Node("function_definition"); 
		$$->insert($1)->insert($2)->insert($3);
	}
	| declarator compound_statement {
		$$ = new Node("function_definition"); 
		$$->insert($1)->insert($2);
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
