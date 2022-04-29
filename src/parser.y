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
%type <TreeNode> unary_expression unary_operator type_specifier direct_declarator
%type <TreeNode> mul_div add_sub shift relation equal_not_equal bitwise_and
%type <TreeNode> xor bitwise_or and or assign expression
%type <TreeNode> declaration declaration_specifiers init_declarator_list
%type <TreeNode> parameter_list parameter_declaration 
%type <TreeNode> assignment_expression statement init_declarator
%type <TreeNode> labeled_statement block declaration_list
%type <TreeNode> statement_list expression_statement selection_statement
%type <TreeNode> iteration_statement jump_statement translation_unit
%type <TreeNode> external_declaration function_definition 
%type <TreeNode> MIF UIF other_statement

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
		$$.nd = new Node("primary_expression");
		$$.nd->insert(new Node("("))->insert($2.nd)->insert(new Node(")"));
	}
	;

postfix_expression
	: primary_expression { 
		$$.nd = new Node("postfix_expression"); 
		$$.nd->insert($1.nd);
	}
	| postfix_expression '(' ')' {
		$$.nd = new Node("postfix_expression"); 
		$$.nd->insert($1.nd);
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
		$$.nd = new Node ("unary_expression");
		$$.nd->insert($1.nd);
	}
	| INC_OP unary_expression {
		$$.nd = new Node ("unary_expression");
		$$.nd->insert(new Node("++"))->insert($2.nd);
	}
	| DEC_OP unary_expression {
		$$.nd = new Node ("unary_expression");
		$$.nd->insert(new Node("--"))->insert($2.nd);
	}
	| unary_operator unary_expression {
		$$.nd = new Node ("unary_expression");
		$$.nd->insert($1.nd)->insert($2.nd);
	}
	;

unary_operator
	: '~' { $$.nd = new Node("unary_operator"); $$.nd->insert(new Node("~")); }
	| '!' { $$.nd = new Node("unary_operator"); $$.nd->insert(new Node("!")); }
	;


mul_div 
	: unary_expression { $$.nd = new Node("mul_div"); $$.nd->insert($1.nd); }
	| mul_div '*' unary_expression {
		$$.nd = new Node("mul_div"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("*"));
		$$.nd->insert($3.nd);
	}
	| mul_div '/' unary_expression {
		$$.nd = new Node("mul_div"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("/"));
		$$.nd->insert($3.nd);
	}
	| mul_div '%' unary_expression {
		$$.nd = new Node("mul_div"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("%"));
		$$.nd->insert($3.nd);
	}
	;

add_sub
	: mul_div { $$.nd = new Node("add_sub"); $$.nd->insert($1.nd); }
	| add_sub '+' mul_div {
		$$.nd = new Node("add_sub"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("+"));
		$$.nd->insert($3.nd);
	}
	| add_sub '-' mul_div {
		$$.nd = new Node("add_sub"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("-"));
		$$.nd->insert($3.nd);
	}
	;

shift
	: add_sub { $$.nd = new Node("shift"); $$.nd->insert($1.nd); }
	| shift LEFT_OP add_sub {
		$$.nd = new Node("shift"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("<<"));
		$$.nd->insert($3.nd);		
	}
	| shift RIGHT_OP add_sub {
		$$.nd = new Node("shift"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node(">>"));
		$$.nd->insert($3.nd);			
	}
	;

relation
	: shift { $$.nd = new Node("relation"); $$.nd->insert($1.nd); }
	| relation '<' shift {
		$$.nd = new Node("relation"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("<"));
		$$.nd->insert($3.nd);	
	}
	| relation '>' shift {
		$$.nd = new Node("relation"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node(">"));
		$$.nd->insert($3.nd);		
	}
	| relation LE_OP shift {
		$$.nd = new Node("relation"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("<="));
		$$.nd->insert($3.nd);
	}
	| relation GE_OP shift {
		$$.nd = new Node("relation"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node(">="));
		$$.nd->insert($3.nd);
	}
	;

equal_not_equal
	: relation { $$.nd = new Node("equal_not_equal"); $$.nd->insert($1.nd); }
	| equal_not_equal EQ_OP relation {
		$$.nd = new Node("equal_not_equal"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("=="));
		$$.nd->insert($3.nd);		
	}
	| equal_not_equal NE_OP relation {
		$$.nd = new Node("equal_not_equal"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("!="));
		$$.nd->insert($3.nd);		
	}
	;

bitwise_and
	: equal_not_equal { $$.nd = new Node("bitwise_and"); $$.nd->insert($1.nd); }
	| bitwise_and '&' equal_not_equal {
		$$.nd = new Node("bitwise_and"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("$"));
		$$.nd->insert($3.nd);			
	}
	;

xor
	: bitwise_and { $$.nd = new Node("xor"); $$.nd->insert($1.nd); }
	| xor '^' bitwise_and {
		$$.nd = new Node("xor"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("^"));
		$$.nd->insert($3.nd);			
	}
	;

bitwise_or
	: xor { $$.nd = new Node("bitwise_or"); $$.nd->insert($1.nd); }
	| bitwise_or '|' xor {
		$$.nd = new Node("bitwise_or"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("|"));
		$$.nd->insert($3.nd);			
	}
	;

and
	: bitwise_or { $$.nd = new Node("and"); $$.nd->insert($1.nd); }
	| and AND_OP bitwise_or {
		$$.nd = new Node("and"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("&&"));
		$$.nd->insert($3.nd);			
	}
	;

or
	: and { $$.nd = new Node("or"); $$.nd->insert($1.nd); }
	| or OR_OP and {
		$$.nd = new Node("or"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("||"));
		$$.nd->insert($3.nd);
	}
	;

assignment_expression
	: or { $$.nd = new Node("assignment_expression"); $$.nd->insert($1.nd); }
	| unary_expression assign assignment_expression {
		$$.nd = new Node("assignment_expression"); 
		$$.nd->insert($1.nd)->insert($2.nd)->insert($3.nd);
	}
	;

assign
	: '=' { $$.nd = new Node($$.name); $$.nd->insert(new Node("=")); }
	| MUL_ASSIGN { $$.nd = new Node($$.name); }
	| DIV_ASSIGN { $$.nd = new Node($$.name); }
	| MOD_ASSIGN { $$.nd = new Node($$.name); }
	| ADD_ASSIGN { $$.nd = new Node($$.name); }
	| SUB_ASSIGN { $$.nd = new Node($$.name); }
	| LEFT_ASSIGN { $$.nd = new Node($$.name); }
	| RIGHT_ASSIGN { $$.nd = new Node($$.name); }
	| AND_ASSIGN { $$.nd = new Node($$.name); }
	| XOR_ASSIGN { $$.nd = new Node($$.name); }
	| OR_ASSIGN { $$.nd = new Node($$.name); }
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
		$$.nd = new Node("declaration_specifiers");
		$$.nd->insert($1.nd);
	}
	| CONST type_specifier {
		$$.nd = new Node("declaration_specifiers");
		$$.nd->insert(new Node("const"));
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
	: direct_declarator { $$.nd = new Node("init_declarator"); $$.nd->insert($1.nd); }
	| direct_declarator '=' assignment_expression {
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

direct_declarator
	: IDENTIFIER { $$.nd = new Node("direct_declarator"); $$.nd->insert(new Node($$.name));}
	| direct_declarator '(' parameter_list ')' {
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
	: declaration_specifiers direct_declarator {
		$$.nd = new Node("parameter_declaration");
		$$.nd->insert($1.nd)->insert($2.nd);		
	}
	| declaration_specifiers { $$.nd = new Node("parameter_declaration"); $$.nd->insert($1.nd); }
	;

statement
	: MIF {$$.nd = new Node("statement"); $$.nd->insert($1.nd); }
  | UIF {$$.nd = new Node("statement"); $$.nd->insert($1.nd); }
	;

other_statement
	: block { $$.nd = new Node("statement"); $$.nd->insert($1.nd); }
	| expression_statement { $$.nd = new Node("statement"); $$.nd->insert($1.nd);}
	| jump_statement { $$.nd = new Node("statement"); $$.nd->insert($1.nd); }
	| selection_statement { $$.nd = new Node("statement"); $$.nd->insert($1.nd);}
  | labeled_statement { $$.nd = new Node("statement"); $$.nd->insert($1.nd);}
	| iteration_statement { $$.nd = new Node("statement"); $$.nd->insert($1.nd);}
  ;

MIF 
  : IF '(' expression ')' MIF ELSE MIF {
    $$.nd = new Node("MIF");
    $$.nd->insert(new Node("if"))->insert(new Node("("))->insert($3.nd);
    $$.nd->insert(new Node(")"))->insert($5.nd)->insert(new Node("else"))->insert($7.nd);
  }
  | other_statement {
    $$.nd = new Node("MIF");
    $$.nd->insert($1.nd);
  }
  ;

UIF 
  : IF '(' expression ')' statement {
    $$.nd = new Node("UIF");
    $$.nd->insert(new Node("if"))->insert(new Node("("))->insert($3.nd);
    $$.nd->insert(new Node(")"))->insert($5.nd);
  }
  | IF '(' expression ')' MIF ELSE UIF {
    $$.nd = new Node("UIF");
    $$.nd->insert(new Node("if"))->insert(new Node("("))->insert($3.nd);
    $$.nd->insert(new Node(")"))->insert($5.nd)->insert(new Node("else"))->insert($7.nd);
  }
  ;

labeled_statement
	: IDENTIFIER ':' block {
		$$.nd = new Node("labeled_statement"); 
		$$.nd->insert(new Node($$.name)); 
		$$.nd->insert(new Node(":")); 
		$$.nd->insert($3.nd); 
	}
	| CASE or ':' block {
		$$.nd = new Node("labeled_statement"); 
		$$.nd->insert(new Node("case")); 
		$$.nd->insert($2.nd); 
		$$.nd->insert(new Node(":")); 
		$$.nd->insert($4.nd);
	}
	| DEFAULT ':' block {
		$$.nd = new Node("labeled_statement"); 
		$$.nd->insert(new Node("default")); 
		$$.nd->insert(new Node(":")); 
		$$.nd->insert($3.nd); 
	}
	;

block
	: '{' '}' {
		$$.nd = new Node("block"); 
		$$.nd->insert(new Node("{")); 
		$$.nd->insert(new Node("}")); 
	}
	| '{' statement_list '}' {
		$$.nd = new Node("block"); 
		$$.nd->insert(new Node("{")); 
		$$.nd->insert($2.nd); 
		$$.nd->insert(new Node("}")); 		
	}
	| '{' declaration_list '}' {
		$$.nd = new Node("block"); 
		$$.nd->insert(new Node("{")); 
		$$.nd->insert($2.nd); 
		$$.nd->insert(new Node("}")); 		
	}
	| '{' declaration_list statement_list '}' {
		$$.nd = new Node("block"); 
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
	: SWITCH '(' expression ')' block {
		$$.nd = new Node("switch"); 
		$$.nd->insert(new Node("("));
		$$.nd->insert($3.nd);
		$$.nd->insert(new Node(")"));
		$$.nd->insert($5.nd);
	}
	;

iteration_statement
	: WHILE '(' expression ')' block {
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
	| FOR '(' expression_statement expression_statement ')' block {
		$$.nd = new Node("iteration_statement"); 
		$$.nd->insert(new Node("for"));
		$$.nd->insert(new Node("("));
		$$.nd->insert($3.nd);
		$$.nd->insert($4.nd);
		$$.nd->insert(new Node(")"));
		$$.nd->insert($6.nd);
	}
	| FOR '(' expression_statement expression_statement expression ')' block {
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
	: declaration_specifiers direct_declarator block {
		$$.nd = new Node("function_definition"); 
		$$.nd->insert($1.nd)->insert($2.nd)->insert($3.nd);
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
