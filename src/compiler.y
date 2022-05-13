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
		struct Node* ASTnd;
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
%token CHAR SHORT INT LONG FLOAT DOUBLE CONST VOID

// If-then-else stmt, while loops, repeat-until loops,
// for loops, switch stmt
%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR BREAK RETURN
/* ------------------------------------------------------------------------- */ 

//start symbol
%start program

%{
/* ------------------------------- includes -------------------------------- */
#include <iostream>
#include "../tree/tree.hh"
#include "../table/table.hh"
#include "../sym/var_sym/var_sym.hh"
#include "../tree/ast/ast.hh"
/* ------------------------------------------------------------------------- */

/* -------------------------- global variables ----------------------------- */
static Node* gParseTree;
static Node* gAST;
static SymbolTable* gSymbolTable = new SymbolTable();
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
%type <TreeNode> switch switch_body block start_block end_block loop
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
	: IDENTIFIER { 
		$$.nd = new Node($1.name);
		$$.ASTnd = new Node("identifier");
	}
	| CONSTANT { 
		$$.nd = new Node($1.name); 
		$$.ASTnd = new Node("constant");
	}
	| '(' expression ')' {
		$$.nd = new Node("basic_element");
		$$.nd->insert(new Node("("))->insert($2.nd)->insert(new Node(")"));
		$$.ASTnd = $2.ASTnd;
	}
	;

//action: push arguments in the stack and goto
function_call
	: basic_element { 
		$$.nd = new Node("function_call"); 
		$$.nd->insert($1.nd);
		$$.ASTnd = $1.ASTnd;
	}
	| function_call '(' ')' {
		$$.nd = new Node("function_call"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("("));
		$$.nd->insert(new Node(")"));
		$$.ASTnd = new Node("function_call");
	}
	| function_call '(' arguments ')' {
		$$.nd = new Node("function_call"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("("));
		$$.nd->insert($3.nd);
		$$.nd->insert(new Node(")"));
		$$.ASTnd = new Node("function_call");
	}
	;

arguments
	: assignment {
		$$.nd = new Node ("arguments");
		$$.nd->insert($1.nd);
		$$.ASTnd = $1.ASTnd;
	}
	| arguments ',' assignment {
		$$.nd = new Node ("arguments");
		$$.nd->insert($1.nd)->insert(new Node(","))->insert($3.nd);
		$$.ASTnd = $1.ASTnd;
		$$.ASTnd->insert($3.ASTnd);
	}
	;

unary_operation
	: function_call {
		$$.nd = new Node ("unary_operation");
		$$.nd->insert($1.nd);
		$$.ASTnd = $1.ASTnd;
	}
	| unary_operator unary_operation {
		$$.nd = new Node ("unary_operation");
		$$.nd->insert($1.nd)->insert($2.nd);
		$$.ASTnd = $1.ASTnd;
		$$.ASTnd->insert($2.ASTnd);
	}
	;

unary_operator
	: '~' { 
		$$.nd = new Node("unary_operator"); 
		$$.nd->insert(new Node("~")); 
		$$.ASTnd = new Node("bitwise_not");
	}
	| '!' { 
		$$.nd = new Node("unary_operator"); 
		$$.nd->insert(new Node("!")); 
		$$.ASTnd = new Node("not");
	}
	;


mul_div_mod 
	: unary_operation { 
		$$.nd = new Node("mul_div_mod"); 
		$$.nd->insert($1.nd); 
		$$.ASTnd = $1.ASTnd;
	}
	| mul_div_mod '*' unary_operation {
		$$.nd = new Node("mul_div_mod"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("*"));
		$$.nd->insert($3.nd);
		$$.ASTnd = new Node("*");
		$$.ASTnd->insert($1.ASTnd)->insert($3.ASTnd);
	}
	| mul_div_mod '/' unary_operation {
		$$.nd = new Node("mul_div_mod"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("/"));
		$$.nd->insert($3.nd);
		$$.ASTnd = new Node("/");
		$$.ASTnd->insert($1.ASTnd)->insert($3.ASTnd);
	}
	| mul_div_mod '%' unary_operation {
		$$.nd = new Node("mul_div_mod"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("%"));
		$$.nd->insert($3.nd);
		$$.ASTnd = new Node("%");
		$$.ASTnd->insert($1.ASTnd)->insert($3.ASTnd);
	}
	;

add_sub
	: mul_div_mod { 
		$$.nd = new Node("add_sub"); 
		$$.nd->insert($1.nd);
		$$.ASTnd = $1.ASTnd;
	}
	| add_sub '+' mul_div_mod {
		$$.nd = new Node("add_sub"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("+"));
		$$.nd->insert($3.nd);
		$$.ASTnd = new Node("+");
		$$.ASTnd->insert($1.ASTnd)->insert($3.ASTnd);
	}
	| add_sub '-' mul_div_mod {
		$$.nd = new Node("add_sub"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("-"));
		$$.nd->insert($3.nd);
		$$.ASTnd = new Node("-");
		$$.ASTnd->insert($1.ASTnd)->insert($3.ASTnd);
	}
	;

shift
	: add_sub { 
		$$.nd = new Node("shift"); 
		$$.nd->insert($1.nd); 
		$$.ASTnd = $1.ASTnd;
		}
	| shift LEFT_OP add_sub {
		$$.nd = new Node("shift"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("<<"));
		$$.nd->insert($3.nd);		
		$$.ASTnd = new Node("<<");
		$$.ASTnd->insert($1.ASTnd)->insert($3.ASTnd);
	}
	| shift RIGHT_OP add_sub {
		$$.nd = new Node("shift"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node(">>"));
		$$.nd->insert($3.nd);			
		$$.ASTnd = new Node(">>");
		$$.ASTnd->insert($1.ASTnd)->insert($3.ASTnd);
	}
	;

relation
	: shift { 
		$$.nd = new Node("relation"); 
		$$.nd->insert($1.nd); 
		$$.ASTnd = $1.ASTnd;
	}
	| relation '<' shift {
		$$.nd = new Node("relation"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("<"));
		$$.nd->insert($3.nd);	
		$$.ASTnd = new Node("<");
		$$.ASTnd->insert($1.ASTnd)->insert($3.ASTnd);
	}
	| relation '>' shift {
		$$.nd = new Node("relation"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node(">"));
		$$.nd->insert($3.nd);		
		$$.ASTnd = new Node(">");
		$$.ASTnd->insert($1.ASTnd)->insert($3.ASTnd);
	}
	| relation LE_OP shift {
		$$.nd = new Node("relation"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("<="));
		$$.nd->insert($3.nd);
		$$.ASTnd = new Node("<=");
		$$.ASTnd->insert($1.ASTnd)->insert($3.ASTnd);
	}
	| relation GE_OP shift {
		$$.nd = new Node("relation"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node(">="));
		$$.nd->insert($3.nd);
		$$.ASTnd = new Node(">=");
		$$.ASTnd->insert($1.ASTnd)->insert($3.ASTnd);
	}
	;

equal_not_equal
	: relation { 
		$$.nd = new Node("equal_not_equal"); 
		$$.nd->insert($1.nd); 
		$$.ASTnd = $1.ASTnd;
	}
	| equal_not_equal EQ_OP relation {
		$$.nd = new Node("equal_not_equal"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("=="));
		$$.nd->insert($3.nd);		
		$$.ASTnd = new Node("==");
		$$.ASTnd->insert($1.ASTnd)->insert($3.ASTnd);
	}
	| equal_not_equal NE_OP relation {
		$$.nd = new Node("equal_not_equal"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("!="));
		$$.nd->insert($3.nd);		
		$$.ASTnd = new Node("!=");
		$$.ASTnd->insert($1.ASTnd)->insert($3.ASTnd);
	}
	;

bitwise_and
	: equal_not_equal { 
		$$.nd = new Node("bitwise_and"); 
		$$.nd->insert($1.nd); 
		$$.ASTnd = $1.ASTnd;
	}
	| bitwise_and '&' equal_not_equal {
		$$.nd = new Node("bitwise_and"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("$"));
		$$.nd->insert($3.nd);			
		$$.ASTnd = new Node("&");
		$$.ASTnd->insert($1.ASTnd)->insert($3.ASTnd);
	}
	;

xor
	: bitwise_and { 
		$$.nd = new Node("xor"); 
		$$.nd->insert($1.nd); 
		$$.ASTnd = $1.ASTnd;
	}
	| xor '^' bitwise_and {
		$$.nd = new Node("xor"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("^"));
		$$.nd->insert($3.nd);			
		$$.ASTnd = new Node("^");
		$$.ASTnd->insert($1.ASTnd)->insert($3.ASTnd);
	}
	;

bitwise_or
	: xor { 
		$$.nd = new Node("bitwise_or"); 
		$$.nd->insert($1.nd); 
		$$.ASTnd = $1.ASTnd;
	}
	| bitwise_or '|' xor {
		$$.nd = new Node("bitwise_or"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("|"));
		$$.nd->insert($3.nd);			
		$$.ASTnd = new Node("|");
		$$.ASTnd->insert($1.ASTnd)->insert($3.ASTnd);
	}
	;

and
	: bitwise_or { 
		$$.nd = new Node("and"); 
		$$.nd->insert($1.nd); 
		$$.ASTnd = $1.ASTnd;
	}
	| and AND_OP bitwise_or {
		$$.nd = new Node("and"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("&&"));
		$$.nd->insert($3.nd);			
		$$.ASTnd = new Node("&&");
		$$.ASTnd->insert($1.ASTnd)->insert($3.ASTnd);
	}
	;

or
	: and { 
		$$.nd = new Node("or"); 
		$$.nd->insert($1.nd); 
		$$.ASTnd = $1.ASTnd;
	}
	| or OR_OP and {
		$$.nd = new Node("or"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("||"));
		$$.nd->insert($3.nd);
		$$.ASTnd = new Node("||");
		$$.ASTnd->insert($1.ASTnd)->insert($3.ASTnd);
	}
	;

assignment
	: or { 
		$$.nd = new Node("assignment");
		$$.nd->insert($1.nd);
		$$.ASTnd = $1.ASTnd;
	}
	| unary_operation assign_operator assignment {
		$$.nd = new Node("assignment"); 
		$$.nd->insert($1.nd)->insert($2.nd)->insert($3.nd);
		$$.ASTnd = $2.ASTnd;
		$$.ASTnd->insert($1.ASTnd)->insert($3.ASTnd);
	}
	;

assign_operator
	: '=' { 
		$$.nd = new Node($$.name); 
		$$.nd->insert(new Node("=")); 
		$$.ASTnd = new Node("="); 
	}
	| MUL_ASSIGN { $$.nd = new Node($$.name); $$.ASTnd = new Node($$.name); }
	| DIV_ASSIGN { $$.nd = new Node($$.name); $$.ASTnd = new Node($$.name); }
	| MOD_ASSIGN { $$.nd = new Node($$.name); $$.ASTnd = new Node($$.name); }
	| ADD_ASSIGN { $$.nd = new Node($$.name); $$.ASTnd = new Node($$.name); }
	| SUB_ASSIGN { $$.nd = new Node($$.name); $$.ASTnd = new Node($$.name); }
	| LEFT_ASSIGN { $$.nd = new Node($$.name); $$.ASTnd = new Node($$.name); }
	| RIGHT_ASSIGN { $$.nd = new Node($$.name); $$.ASTnd = new Node($$.name); }
	| AND_ASSIGN { $$.nd = new Node($$.name); $$.ASTnd = new Node($$.name); }
	| XOR_ASSIGN { $$.nd = new Node($$.name); $$.ASTnd = new Node($$.name); }
	| OR_ASSIGN { $$.nd = new Node($$.name); $$.ASTnd = new Node($$.name); }
	;

expression
	: assignment { 
		$$.nd = new Node("expression");
	 	$$.nd->insert($1.nd); 
		$$.ASTnd = $1.ASTnd;
	}
	| expression ',' assignment {
		$$.nd = new Node("expression");
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node(","));
		$$.nd->insert($3.nd);
		$$.ASTnd = $1.ASTnd;
		$$.ASTnd->insert($3.ASTnd);
	}
	;

declaration
	: var_const IDENTIFIER ';' {
		$$.nd = new Node("declaration");
		$$.nd->insert($1.nd)->insert(new Node($2.name))->insert(new Node(";"));
		$$.ASTnd = new Declaration("declaration", 
		dynamic_cast<VarConst*>($1.ASTnd), $2.name);
		
		// Lookup the symbol table, if exist return symantic error (redefinition)
		Symbol* sym = gSymbolTable->LookUp($2.name);
		if(NULL != sym && sym->scope == gSymbolTable->level) {
			std::cout << "[ERROR]: redefinition" << std::endl;
		} 
		// otherwise, add it to the symbol table
		else {
			sym = new Symbol($2.name, gSymbolTable->level);
			gSymbolTable->insert($2.name, sym);
		}
	}
	| var_const IDENTIFIER '=' assignment ';' {
		$$.nd = new Node("declaration");
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node($2.name));
		$$.nd->insert(new Node("="));
		$$.nd->insert($4.nd);
		$$.nd->insert(new Node(";"));
		$$.ASTnd = new Declaration("declaration", dynamic_cast<VarConst*>($1.ASTnd), $2.name);
		$$.ASTnd->insert($4.ASTnd);
	}
	;

var_const
	: datatype {
		$$.nd = new Node("var_const");
		$$.nd->insert($1.nd);
		$$.ASTnd = new VarConst("var_const", dynamic_cast<DatatypeNode *>($1.ASTnd), false);
	}
	| CONST datatype {
		$$.nd = new Node("var_const");
		$$.nd->insert(new Node("const"));
		$$.ASTnd = new VarConst("var_const", dynamic_cast<DatatypeNode *>($2.ASTnd), true);
	}
	;

datatype
	: VOID { 
		$$.nd = new Node("datatype"); 
		$$.nd->insert(new Node("void")); 
		$$.ASTnd = new DatatypeNode("void", Datatype::VOID);
	}
	| CHAR { 
		$$.nd = new Node("datatype"); 
		$$.nd->insert(new Node("char")); 
		$$.ASTnd = new DatatypeNode("char", Datatype::CHAR);
	}
	| SHORT { 
		$$.nd = new Node("datatype"); 
		$$.nd->insert(new Node("short")); 
		$$.ASTnd = new DatatypeNode("short", Datatype::SHORT);
	}
	| INT { 
		$$.nd = new Node("datatype"); 
		$$.nd->insert(new Node("int")); 
		$$.ASTnd = new DatatypeNode("int", Datatype::INT);
	}
	| LONG { 
		$$.nd = new Node("datatype"); 
		$$.nd->insert(new Node("long")); 
		$$.ASTnd = new DatatypeNode("long", Datatype::LONG);
	}
	| FLOAT { 
		$$.nd = new Node("datatype"); 
		$$.nd->insert(new Node("float")); 
		$$.ASTnd = new DatatypeNode("float", Datatype::FLOAT);
	}
	| DOUBLE { 
		$$.nd = new Node("datatype"); 
		$$.nd->insert(new Node("double")); 
		$$.ASTnd = new DatatypeNode("double", Datatype::DOUBLE);
	}
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
	: MIF { $$.nd = new Node("stmt"); $$.nd->insert($1.nd); $$.ASTnd = $1.ASTnd; }
  | UIF { $$.nd = new Node("stmt"); $$.nd->insert($1.nd); $$.ASTnd = $1.ASTnd; }
	;

other_stmt
	: block { $$.nd = new Node("stmt"); $$.nd->insert($1.nd); $$.ASTnd = $1.ASTnd; }
	| expression_stmt { $$.nd = new Node("stmt"); $$.nd->insert($1.nd); $$.ASTnd = $1.ASTnd; }
	| return { $$.nd = new Node("stmt"); $$.nd->insert($1.nd); $$.ASTnd = $1.ASTnd; }
	| switch { $$.nd = new Node("stmt"); $$.nd->insert($1.nd); $$.ASTnd = $1.ASTnd; }
	| loop { $$.nd = new Node("stmt"); $$.nd->insert($1.nd); $$.ASTnd = $1.ASTnd; }
  ;

//action: jump based on the expression
MIF 
  : IF '(' expression ')' MIF ELSE MIF {
    $$.nd = new Node("MIF");
    $$.nd->insert(new Node("if"))->insert(new Node("("))->insert($3.nd);
    $$.nd->insert(new Node(")"))->insert($5.nd)->insert(new Node("else"))->insert($7.nd);
		
    $$.ASTnd = new Node("MIF");
		$$.ASTnd->insert($3.ASTnd)->insert($5.ASTnd)->insert($7.ASTnd);
	}
  | other_stmt {
    $$.nd = new Node("MIF");
    $$.nd->insert($1.nd);
    $$.ASTnd = $1.ASTnd;
  }
  ;

UIF 
  : IF '(' expression ')' stmt {
    $$.nd = new Node("UIF");
    $$.nd->insert(new Node("if"))->insert(new Node("("))->insert($3.nd);
    $$.nd->insert(new Node(")"))->insert($5.nd);
		
		$$.ASTnd = new Node("UIF");
		$$.ASTnd->insert($3.ASTnd)->insert($5.ASTnd);
  }
  | IF '(' expression ')' MIF ELSE UIF {
    $$.nd = new Node("UIF");
    $$.nd->insert(new Node("if"))->insert(new Node("("))->insert($3.nd);
    $$.nd->insert(new Node(")"))->insert($5.nd)->insert(new Node("else"))->insert($7.nd);
		
		$$.ASTnd = new Node("UIF");
		$$.ASTnd->insert($3.ASTnd)->insert($5.ASTnd)->insert($7.ASTnd);
  }
  ;

start_block 
	: '{' { 
		$$.nd = new Node("{"); 
		gSymbolTable = new SymbolTable(gSymbolTable);
	}
	;
end_block 
	: '}' { 
		$$.nd = new Node("}"); 
		SymbolTable* temp = gSymbolTable;
		gSymbolTable = gSymbolTable->prev;
		delete temp;
	}
	;

block
	: start_block end_block {
		$$.nd = new Node("block"); 
		$$.nd->insert($1.nd)->insert($2.nd); 
	}
	| start_block stmts end_block {
		$$.nd = new Node("block"); 
		$$.nd->insert($1.nd)->insert($2.nd)->insert($3.nd); 
		$$.ASTnd = $2.ASTnd;
	}
	| start_block declarations end_block {
		$$.nd = new Node("block"); 
		$$.nd->insert($1.nd)->insert($2.nd)->insert($3.nd); 
		$$.ASTnd = $2.ASTnd;
	}
	| start_block declarations stmts end_block {
		$$.nd = new Node("block"); 
		$$.nd->insert($1.nd)->insert($2.nd)->insert($3.nd)->insert($4.nd); 
		$$.ASTnd = $2.ASTnd;
		$$.ASTnd->insert($3.ASTnd);
	}
	;

declarations
	: declaration { 
		$$.nd = new Node("declarations"); 
		$$.nd->insert($1.nd); 
		$$.ASTnd = $1.ASTnd;
	}
	| declarations declaration {
		$$.nd = new Node("declarations"); $$.nd->insert($1.nd)->insert($2.nd);
		$$.ASTnd = $1.ASTnd;
		$$.ASTnd->insert($2.ASTnd);
	}
	;

stmts
	: stmt { 
		$$.nd = new Node("stmts"); 
		$$.nd->insert($1.nd);
		$$.ASTnd = $1.ASTnd;
	}
	| stmts stmt {
		$$.nd = new Node("stmts"); 
		$$.nd->insert($1.nd)->insert($2.nd);
		$$.ASTnd = $1.ASTnd;
		$$.ASTnd->insert($2.ASTnd);
	}
	;

expression_stmt
	: ';' { 
		$$.nd = new Node("expression_stmt"); 
		$$.nd->insert(new Node(";"));
		$$.ASTnd = new Node("NOP");
	}
	| expression ';' {
		$$.nd = new Node("expression_stmt"); 
		$$.nd->insert($1.nd)->insert(new Node(";"));
		$$.ASTnd = $1.ASTnd;
	}
	;

//action: if(temp == constant) {enter call body jump out of the switch }
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
		$$.ASTnd = new Node("case");
		$$.ASTnd->insert($4.ASTnd)->insert($7.ASTnd);
	}
	| DEFAULT ':' block BREAK ';' {
		$$.nd = new Node("labeled_stmt"); 
		$$.nd->insert(new Node("default")); 
		$$.nd->insert(new Node(":")); 
		$$.nd->insert($3.nd); 
		$$.nd->insert(new Node("break")); 
		$$.nd->insert(new Node(";")); 
		$$.ASTnd = new Node("default");
		$$.ASTnd->insert($3.ASTnd);
	}

//action: read identifier and store it in a temp, call switch body
//ref: https://fog.ccsf.edu/~gboyd/cs270/online/mipsII/switch.html
switch
	: SWITCH '(' IDENTIFIER ')' start_block switch_body end_block {
		$$.nd = new Node("switch"); 
		$$.nd->insert(new Node("("));
		$$.nd->insert(new Node($3.name));
		$$.nd->insert(new Node(")"));
		$$.nd->insert(new Node("{"));
		$$.nd->insert($6.nd);
		$$.nd->insert(new Node("}"));
		$$.ASTnd = new Node("switch");
		$$.ASTnd->insert($6.ASTnd);
	}
	;

//action: Add a label, call body, end with a goto under the expression
loop
	: WHILE '(' expression ')' block {
		$$.nd = new Node("loop"); 
		$$.nd->insert(new Node("while"));
		$$.nd->insert(new Node("("));
		$$.nd->insert($3.nd);
		$$.nd->insert(new Node(")"));
		$$.nd->insert($5.nd);
		$$.ASTnd = new Node("while");
		$$.ASTnd->insert($3.ASTnd)->insert($5.ASTnd);
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
		$$.ASTnd = new Node("DoWhile");
		$$.ASTnd->insert($2.ASTnd)->insert($5.ASTnd);
	}
	| FOR '(' expression_stmt expression_stmt ')' block {
		$$.nd = new Node("loop"); 
		$$.nd->insert(new Node("for"));
		$$.nd->insert(new Node("("));
		$$.nd->insert($3.nd);
		$$.nd->insert($4.nd);
		$$.nd->insert(new Node(")"));
		$$.nd->insert($6.nd);
		$$.ASTnd = new Node("for");
		$$.ASTnd->insert($3.ASTnd)->insert($4.ASTnd)->insert($6.ASTnd);
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
		$$.ASTnd = new Node("for");
		$$.ASTnd->insert($3.ASTnd)->insert($4.ASTnd)->insert($5.ASTnd)->insert($7.ASTnd);
	}
	;


//action: goto + push
return
  : RETURN ';' { 
    $$.nd = new Node("return"); 
    $$.nd->insert(new Node("return"))->insert(new Node(";")); 
		$$.ASTnd = new Node("return");
	}
  | RETURN expression ';' { 
  	$$.nd = new Node("return"); 
  	$$.nd->insert(new Node("return"))->insert($2.nd)->insert(new Node(";")); 
		$$.ASTnd = new Node("return");
  }
	;

program: c_file { gParseTree = $1.nd; gAST = $1.ASTnd;}

c_file
	: function_global_var {
		$$.nd = new Node("c_file");
		$$.nd->insert($1.nd);
		$$.ASTnd = $1.ASTnd;
	}
	| c_file function_global_var {
		$$.nd = new Node("c_file"); 
		$$.nd->insert($1.nd)->insert($2.nd);
		$$.ASTnd = $1.ASTnd;
		$$.ASTnd->insert($2.ASTnd);
	}
	;

function_global_var
  : function_signature block {
		$$.nd = new Node("function_global_var"); 
		$$.nd->insert($1.nd)->insert($2.nd);
		$$.ASTnd = $1.ASTnd;
		$$.ASTnd->insert($2.ASTnd);
	}
  | function_signature ';' {
		$$.nd = new Node("function_global_var"); 
		$$.nd->insert($1.nd)->insert(new Node(";"));
		$$.ASTnd = $1.ASTnd;
  }
	| declaration { 
		$$.nd = new Node("function_global_var"); 
		$$.nd->insert($1.nd);
		$$.ASTnd = $1.ASTnd;
	}
	;

//Action: just write the function label
function_signature
	: var_const IDENTIFIER '(' parameters ')' {
		$$.nd = new Node("function_signature"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node($2.name));
		$$.nd->insert(new Node("("));		
		$$.nd->insert($4.nd);
		$$.nd->insert(new Node(")"));		
		$$.ASTnd = new Node("function_signature"); 
	}
	| var_const IDENTIFIER '(' ')' {
		$$.nd = new Node("function_signature"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node($2.name));
		$$.nd->insert(new Node("("));
		$$.nd->insert(new Node(")"));		
		$$.ASTnd = new Node("function_signature"); 
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

Node* getAST ()
{
	return gAST;
}
/* ------------------------------------------------------------------------- */

/* ------------------------------------------------------------------------- */
/* ---------------------------- END subroutines ---------------------------- */
/* ------------------------------------------------------------------------- */

/* ------------------------------- END FILE ------------------------------- */
