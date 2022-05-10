/**
@file: parser.y
@brief: A parser for ANSI C language
@author: Mohamed Hassanin
*/

/* ------------------------------------------------------------------------- */
/* --------------------------- YACC Definitions ---------------------------- */
/* ------------------------------------------------------------------------- */
/* ------------------------- Type Declarations ----------------------------- */
%union {
	struct {
		char name[50];
		struct Node* nd;
	} TreeNode;
}

/* ------------------------- Tokens Definitions ---------------------------- */
// Variables and Constants declaration
%token <TreeNode> IDENTIFIER CONSTANT

// unary operators
%token  LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP 

// Assignment stmts
%token <TreeNode> MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token <TreeNode> SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token <TreeNode> XOR_ASSIGN OR_ASSIGN

// Data types
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOID

// If-then-else stmt, while loops, repeat-until loops,
// for loops, switch stmt
%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR BREAK RETURN
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

%type <TreeNode> function_global_var c_file
%type <TreeNode> basic_element function_call
%type <TreeNode> unary_operation unary_operator datatype 
%type <TreeNode> declaration var_const function_signature
%type <TreeNode> expression_stmt declarations
%type <TreeNode> return parameters arguments
%type <TreeNode> mul_div_mod add_sub shift relation equal_not_equal bitwise_and
%type <TreeNode> xor bitwise_or and or assign_operator expression
%type <TreeNode> switch switch_body block loop
%type <TreeNode> assignment stmts stmt other_stmt
%type <TreeNode> MIF UIF 

/* ------------------------------------------------------------------------- */
/* ------------------------------------------------------------------------- */
/* ------------------------- END YACC Definitions -------------------------- */
/* ------------------------------------------------------------------------- */
%%
/* ------------------------------------------------------------------------- */
/* ------------------------------- YACC Rules ------------------------------ */
/* ------------------------------------------------------------------------- */


/* Precedence decreases as you go down */
basic_element
	: IDENTIFIER { $$.nd = new Node($1.name); }
	| CONSTANT { $$.nd = new Node($1.name); }
	| '(' expression ')' {
		$$.nd = new Node("basic_element");
		$$.nd->insert(new Node("("))->insert($2.nd)->insert(new Node(")"));
	}
	;

function_call
	: basic_element { 
		$$.nd = new Node("function_call"); 
		$$.nd->insert($1.nd);
	}
	| function_call '(' ')' {
		$$.nd = new Node("function_call"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("("));
		$$.nd->insert(new Node(")"));
	}
	| function_call '(' arguments ')' {
		$$.nd = new Node("function_call"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("("));
		$$.nd->insert($3.nd);
		$$.nd->insert(new Node(")"));
	}
	;

arguments
	: assignment {
		$$.nd = new Node ("arguments");
		$$.nd->insert($1.nd);
	}
	| arguments ',' assignment {
		$$.nd = new Node ("arguments");
		$$.nd->insert($1.nd)->insert(new Node(","))->insert($3.nd);
	}
	;

unary_operation
	: function_call {
		$$.nd = new Node ("unary_operation");
		$$.nd->insert($1.nd);
	}
	| unary_operator unary_operation {
		$$.nd = new Node ("unary_operation");
		$$.nd->insert($1.nd)->insert($2.nd);
	}
	;

unary_operator
	: '~' { $$.nd = new Node("unary_operator"); $$.nd->insert(new Node("~")); }
	| '!' { $$.nd = new Node("unary_operator"); $$.nd->insert(new Node("!")); }
	;


mul_div_mod 
	: unary_operation { $$.nd = new Node("mul_div_mod"); $$.nd->insert($1.nd); }
	| mul_div_mod '*' unary_operation {
		$$.nd = new Node("mul_div_mod"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("*"));
		$$.nd->insert($3.nd);
	}
	| mul_div_mod '/' unary_operation {
		$$.nd = new Node("mul_div_mod"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("/"));
		$$.nd->insert($3.nd);
	}
	| mul_div_mod '%' unary_operation {
		$$.nd = new Node("mul_div_mod"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("%"));
		$$.nd->insert($3.nd);
	}
	;

add_sub
	: mul_div_mod { $$.nd = new Node("add_sub"); $$.nd->insert($1.nd); }
	| add_sub '+' mul_div_mod {
		$$.nd = new Node("add_sub"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("+"));
		$$.nd->insert($3.nd);
	}
	| add_sub '-' mul_div_mod {
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

assignment
	: or { $$.nd = new Node("assignment"); $$.nd->insert($1.nd); }
	| unary_operation assign_operator assignment {
		$$.nd = new Node("assignment"); 
		$$.nd->insert($1.nd)->insert($2.nd)->insert($3.nd);
	}
	;

assign_operator
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
	: assignment { $$.nd = new Node("expression"); $$.nd->insert($1.nd); }
	| expression ',' assignment {
		$$.nd = new Node("expression");
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node(","));
		$$.nd->insert($3.nd);
	}
	;

declaration
	: var_const IDENTIFIER';' {
		$$.nd = new Node("declaration");
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node($2.name));
		$$.nd->insert(new Node(";"));
	}
	| var_const IDENTIFIER '=' assignment ';' {
		$$.nd = new Node("declaration");
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node($2.name));
		$$.nd->insert(new Node("="));
		$$.nd->insert($4.nd);
		$$.nd->insert(new Node(";"));
	}
	;

var_const
	: datatype {
		$$.nd = new Node("var_const");
		$$.nd->insert($1.nd);
	}
	| CONST datatype {
		$$.nd = new Node("var_const");
		$$.nd->insert(new Node("const"));
	}
	;

datatype
	: VOID { $$.nd = new Node("datatype"); $$.nd->insert(new Node("void")); }
	| CHAR { $$.nd = new Node("datatype"); $$.nd->insert(new Node("char")); }
	| SHORT { $$.nd = new Node("datatype"); $$.nd->insert(new Node("short")); }
	| INT { $$.nd = new Node("datatype"); $$.nd->insert(new Node("int")); }
	| LONG { $$.nd = new Node("datatype"); $$.nd->insert(new Node("long")); }
	| FLOAT { $$.nd = new Node("datatype"); $$.nd->insert(new Node("float")); }
	| DOUBLE { $$.nd = new Node("datatype"); $$.nd->insert(new Node("double")); }
	| SIGNED { $$.nd = new Node("datatype"); $$.nd->insert(new Node("signed")); }
	| UNSIGNED { $$.nd = new Node("datatype"); $$.nd->insert(new Node("unsigned")); }
	;


parameters
	: var_const IDENTIFIER { 
    $$.nd = new Node("parameters");
    $$.nd->insert($1.nd); 
    $$.nd->insert(new Node($2.name)); 
  }
	| parameters ',' var_const IDENTIFIER {
		$$.nd = new Node("parameters"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node(","));
		$$.nd->insert($3.nd);
    $$.nd->insert(new Node($4.name)); 
	}
	;

stmt
	: MIF {$$.nd = new Node("stmt"); $$.nd->insert($1.nd); }
  | UIF {$$.nd = new Node("stmt"); $$.nd->insert($1.nd); }
	;

other_stmt
	: block { $$.nd = new Node("stmt"); $$.nd->insert($1.nd); }
	| expression_stmt { $$.nd = new Node("stmt"); $$.nd->insert($1.nd);}
	| return { $$.nd = new Node("stmt"); $$.nd->insert($1.nd); }
	| switch { $$.nd = new Node("stmt"); $$.nd->insert($1.nd);}
	| loop { $$.nd = new Node("stmt"); $$.nd->insert($1.nd);}
  ;

MIF 
  : IF '(' expression ')' MIF ELSE MIF {
    $$.nd = new Node("MIF");
    $$.nd->insert(new Node("if"))->insert(new Node("("))->insert($3.nd);
    $$.nd->insert(new Node(")"))->insert($5.nd)->insert(new Node("else"))->insert($7.nd);
  }
  | other_stmt {
    $$.nd = new Node("MIF");
    $$.nd->insert($1.nd);
  }
  ;

UIF 
  : IF '(' expression ')' stmt {
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

block
	: '{' '}' {
		$$.nd = new Node("block"); 
		$$.nd->insert(new Node("{")); 
		$$.nd->insert(new Node("}")); 
	}
	| '{' stmts '}' {
		$$.nd = new Node("block"); 
		$$.nd->insert(new Node("{")); 
		$$.nd->insert($2.nd); 
		$$.nd->insert(new Node("}")); 		
	}
	| '{' declarations '}' {
		$$.nd = new Node("block"); 
		$$.nd->insert(new Node("{")); 
		$$.nd->insert($2.nd); 
		$$.nd->insert(new Node("}")); 		
	}
	| '{' declarations stmts '}' {
		$$.nd = new Node("block"); 
		$$.nd->insert(new Node("{")); 
		$$.nd->insert($2.nd); 
		$$.nd->insert($3.nd); 
		$$.nd->insert(new Node("}")); 
	}
	;

declarations
	: declaration { $$.nd = new Node("declarations"); $$.nd->insert($1.nd); }
	| declarations declaration {
		$$.nd = new Node("declarations"); $$.nd->insert($1.nd)->insert($2.nd);
	}
	;

stmts
	: stmt { $$.nd = new Node("stmts"); $$.nd->insert($1.nd); }
	| stmts stmt {
		$$.nd = new Node("stmts"); $$.nd->insert($1.nd)->insert($2.nd);
	}
	;

expression_stmt
	: ';' { 
		$$.nd = new Node("expression_stmt"); 
		$$.nd->insert(new Node(";"));
	}
	| expression ';' {
		$$.nd = new Node("expression_stmt"); 
		$$.nd->insert($1.nd)->insert(new Node(";"));
	}
	;

switch_body
  : CASE CONSTANT ':' block BREAK ';' switch_body {
		$$.nd = new Node("labeled_stmt"); 
		$$.nd->insert(new Node("case")); 
		$$.nd->insert(new Node($2.name)); 
		$$.nd->insert(new Node(":")); 
		$$.nd->insert($4.nd);
		$$.nd->insert(new Node("break")); 
		$$.nd->insert(new Node(";")); 
		$$.nd->insert($7.nd);
	}
	| DEFAULT ':' block BREAK ';' {
		$$.nd = new Node("labeled_stmt"); 
		$$.nd->insert(new Node("default")); 
		$$.nd->insert(new Node(":")); 
		$$.nd->insert($3.nd); 
		$$.nd->insert(new Node("break")); 
		$$.nd->insert(new Node(";")); 
	}

switch
	: SWITCH '(' expression ')' '{' switch_body '}' {
		$$.nd = new Node("switch"); 
		$$.nd->insert(new Node("("));
		$$.nd->insert($3.nd);
		$$.nd->insert(new Node(")"));
		$$.nd->insert(new Node("{"));
		$$.nd->insert($6.nd);
		$$.nd->insert(new Node("}"));
	}
	;

loop
	: WHILE '(' expression ')' block {
		$$.nd = new Node("loop"); 
		$$.nd->insert(new Node("while"));
		$$.nd->insert(new Node("("));
		$$.nd->insert($3.nd);
		$$.nd->insert(new Node(")"));
		$$.nd->insert($5.nd);
	}
	| DO stmt WHILE '(' expression ')' ';' {
		$$.nd = new Node("loop"); 
		$$.nd->insert(new Node("do"));
		$$.nd->insert($2.nd);
		$$.nd->insert(new Node("while"));
		$$.nd->insert(new Node("("));
		$$.nd->insert($5.nd);
		$$.nd->insert(new Node(")"));
		$$.nd->insert(new Node(";"));
	}
	| FOR '(' expression_stmt expression_stmt ')' block {
		$$.nd = new Node("loop"); 
		$$.nd->insert(new Node("for"));
		$$.nd->insert(new Node("("));
		$$.nd->insert($3.nd);
		$$.nd->insert($4.nd);
		$$.nd->insert(new Node(")"));
		$$.nd->insert($6.nd);
	}
	| FOR '(' expression_stmt expression_stmt expression ')' block {
		$$.nd = new Node("loop"); 
		$$.nd->insert(new Node("for"));
		$$.nd->insert(new Node("("));
		$$.nd->insert($3.nd);
		$$.nd->insert($4.nd);
		$$.nd->insert($5.nd);		
		$$.nd->insert(new Node(")"));
		$$.nd->insert($7.nd);		
	}
	;

return
  : RETURN ';' { 
    $$.nd = new Node("return"); 
    $$.nd->insert(new Node("return"))->insert(new Node(";")); 
	}
  | RETURN expression ';' { 
  	$$.nd = new Node("return"); 
  	$$.nd->insert(new Node("return"))->insert($2.nd)->insert(new Node(";")); 
  }
	;

program: c_file { gParseTree = $1.nd; }

c_file
	: function_global_var {
		$$.nd = new Node("c_file");
		$$.nd->insert($1.nd);
	}
	| c_file function_global_var {
		$$.nd = new Node("c_file"); 
		$$.nd->insert($1.nd)->insert($2.nd);
	}
	;

function_global_var
  : function_signature block {
		$$.nd = new Node("function_global_var"); 
		$$.nd->insert($1.nd)->insert($2.nd);
	}
  | function_signature ';' {
		$$.nd = new Node("function_global_var"); 
		$$.nd->insert($1.nd)->insert(new Node(";"));
  }
	| declaration { 
		$$.nd = new Node("function_global_var"); 
		$$.nd->insert($1.nd);
	}
	;

function_signature
	: var_const IDENTIFIER '(' parameters ')' {
		$$.nd = new Node("declarator"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node($2.name));
		$$.nd->insert(new Node("("));		
		$$.nd->insert($4.nd);
		$$.nd->insert(new Node(")"));		
	}
	| var_const IDENTIFIER '(' ')' {
		$$.nd = new Node("declarator"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node($2.name));
		$$.nd->insert(new Node("("));
		$$.nd->insert(new Node(")"));		
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
