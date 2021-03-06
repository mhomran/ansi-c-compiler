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
%token <TreeNode> IDENTIFIER 
%token <TreeNode> INTEGER_CONSTANT FLOATING_CONSTANT

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
#include <sstream>
#include "../tree/tree.hh"
#include "../table/table.hh"
#include "../sym/var_sym/var_sym.hh"
#include "../tree/ast/ast.hh"
/* ------------------------------------------------------------------------- */

/* -------------------------- global variables ----------------------------- */
static Node* gParseTree;
static Node* gAST;
static std::ofstream st_fd;
static std::ofstream wr_fd;
static std::ofstream er_fd;
static SymbolTable* gSymbolTable = new SymbolTable(wr_fd);

/* ------------------------------------------------------------------------- */

/* ----------------------- extern global variables ------------------------- */
extern int column;
extern int line;
/* ------------------------------------------------------------------------- */

/* ------------------------- Functions prototypes -------------------------- */
int yylex(void);
void yyerror (char const *s);
void yydtor (void);
void yyctor (void);

Node* getParseTree ();
Node* getAST();
void insertVariable(string, Datatype, bool, bool);
std::ofstream& getErrorFd ();

/* ------------------------------------------------------------------------- */
%}
%type <TreeNode> constant identifier
%type <TreeNode> function_global_var c_file
%type <TreeNode> basic_element function_call
%type <TreeNode> unary_operation unary_operator datatype 
%type <TreeNode> declaration var_const function_signature
%type <TreeNode> expression_stmt declarations
%type <TreeNode> return parameters arguments
%type <TreeNode> mul_div_mod add_sub shift relation equal_not_equal 
%type <TreeNode> and or assign_operator expression
%type <TreeNode> xor bitwise_or bitwise_and
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
identifier
	: IDENTIFIER { 
    std::ostringstream buffer;
		Symbol* sym = gSymbolTable->LookUp($1.name);
		$$.nd = new Node($1.name);

		if(NULL == sym) {
			buffer << "[ERROR]: @ line " << line << " " << $1.name << " undefined variable." << std::endl;
			throw buffer.str();
		} else {
			VarSymbol* temp = dynamic_cast<VarSymbol*>(sym);
			if(NULL == temp) {
				buffer << "[ERROR]: @ line " << line << " " << $1.name << " is a function not a variable." << std::endl;
				throw buffer.str();
			} else {
				temp->setIsUsed(true);
				if(!(temp->getIsInitialized())) {
					cout << "[WARNING]: @ line " << line << " " << $1.name << " used before initialized." << std::endl;
					wr_fd << "[WARNING]: @ line " << line << " " << $1.name << " used before initialized." << std::endl;
				}
				$$.ASTnd = new Identifier($1.name, temp->getDatatype());
			}
		}
	}
	;
basic_element
	: identifier {
		$$.nd = new Node("identifier"); 
		$$.nd->insert($1.nd);
		$$.ASTnd = $1.ASTnd;
	}
	| constant { 
		$$.nd = new Node("constant"); 
		$$.nd->insert($1.nd);
		$$.ASTnd = $1.ASTnd;
	}
	| '(' expression ')' {
		$$.nd = new Node("basic_element");
		$$.nd->insert(new Node("("))->insert($2.nd)->insert(new Node(")"));
		$$.ASTnd = $2.ASTnd;
	}
	;

constant
	: INTEGER_CONSTANT { 
		$$.nd = new Node($1.name); 
		$$.ASTnd = new IntConstant($1.name);
	}
	| FLOATING_CONSTANT { 
		$$.nd = new Node($1.name); 
		$$.ASTnd = new FloatConstant($1.name);
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
		$$.ASTnd = new BitwiseNot("bitwise_not");
	}
	| '!' { 
		$$.nd = new Node("unary_operator"); 
		$$.nd->insert(new Node("!")); 
		$$.ASTnd = new Not("not");
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
		$$.ASTnd = new Mul("*");
		$$.ASTnd->insert($1.ASTnd)->insert($3.ASTnd);
	}
	| mul_div_mod '/' unary_operation {
		$$.nd = new Node("mul_div_mod"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("/"));
		$$.nd->insert($3.nd);
		$$.ASTnd = new Div("/");
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
		$$.ASTnd = new Add("+");
		$$.ASTnd->insert($1.ASTnd)->insert($3.ASTnd);
	}
	| add_sub '-' mul_div_mod {
		$$.nd = new Node("add_sub"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("-"));
		$$.nd->insert($3.nd);
		$$.ASTnd = new Sub("-");
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
		$$.ASTnd = new ShiftLeft("<<");
		$$.ASTnd->insert($1.ASTnd)->insert($3.ASTnd);
	}
	| shift RIGHT_OP add_sub {
		$$.nd = new Node("shift"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node(">>"));
		$$.nd->insert($3.nd);			
		$$.ASTnd = new ShiftRight(">>");
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
		$$.ASTnd = new Lower("<");
		$$.ASTnd->insert($1.ASTnd)->insert($3.ASTnd);
	}
	| relation '>' shift {
		$$.nd = new Node("relation"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node(">"));
		$$.nd->insert($3.nd);		
		$$.ASTnd = new Greater(">");
		$$.ASTnd->insert($1.ASTnd)->insert($3.ASTnd);
	}
	| relation LE_OP shift {
		$$.nd = new Node("relation"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("<="));
		$$.nd->insert($3.nd);
		$$.ASTnd = new LowerEqual("<=");
		$$.ASTnd->insert($1.ASTnd)->insert($3.ASTnd);
	}
	| relation GE_OP shift {
		$$.nd = new Node("relation"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node(">="));
		$$.nd->insert($3.nd);
		$$.ASTnd = new GreaterEqual(">=");
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
		$$.ASTnd = new Equal("==");
		$$.ASTnd->insert($1.ASTnd)->insert($3.ASTnd);
	}
	| equal_not_equal NE_OP relation {
		$$.nd = new Node("equal_not_equal"); 
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node("!="));
		$$.nd->insert($3.nd);		
		$$.ASTnd = new NotEqual("!=");
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
		$$.ASTnd = new BitwiseAnd("&");
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
		$$.ASTnd = new BitwiseXor("^");
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
		$$.ASTnd = new BitwiseOr("|");
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
		$$.ASTnd = new And("&&");
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
		$$.ASTnd = new Or("||");
		$$.ASTnd->insert($1.ASTnd)->insert($3.ASTnd);
	}
	;

assignment
	: or { 
		$$.nd = new Node("assignment");
		$$.nd->insert($1.nd);
		$$.ASTnd = $1.ASTnd;
	}
	| identifier assign_operator assignment {
		$$.nd = new Node("assignment"); 
		$$.nd->insert($1.nd)->insert($2.nd)->insert($3.nd);
		$$.ASTnd = new Assignment("assignment", $1.name); 
		$$.ASTnd->insert($3.ASTnd)->insert($2.ASTnd);

    std::ostringstream buffer;
		Symbol* sym = gSymbolTable->LookUp($1.name);
		if(NULL == sym) {
			buffer << "[ERROR]: @ line " << line << " " 
			<< $1.name << " undefined symbol." << std::endl;
			throw buffer.str();
		} else {
			VarSymbol* temp = dynamic_cast<VarSymbol*>(sym);
			if(NULL == temp) {
				buffer << "[ERROR]: @ line " << line << " " 
				<< $1.name << " is a function not a variable." << std::endl;
				throw buffer.str();
			} else {
				if(temp->getIsConst()) {
					buffer << "[ERROR]: @ line " << line << " " 
					<< $1.name << " is a read-only." << std::endl;
					throw buffer.str();
				} else {
					temp->setIsInitialized(true);
				}
			}
		}
	}
	;

assign_operator
	: '=' { 
		$$.nd = new Node($$.name); 
		$$.nd->insert(new Node("=")); 
		$$.ASTnd = new AssignOp("="); 
	}
	| MUL_ASSIGN { $$.nd = new Node($$.name); $$.ASTnd = new Mul($$.name); }
	| DIV_ASSIGN { $$.nd = new Node($$.name); $$.ASTnd = new Div($$.name); }
	| MOD_ASSIGN { $$.nd = new Node($$.name); $$.ASTnd = new Mod($$.name); }
	| ADD_ASSIGN { $$.nd = new Node($$.name); $$.ASTnd = new Add($$.name); }
	| SUB_ASSIGN { $$.nd = new Node($$.name); $$.ASTnd = new Sub($$.name); }
	| LEFT_ASSIGN { $$.nd = new Node($$.name); $$.ASTnd = new ShiftLeft($$.name); }
	| RIGHT_ASSIGN { $$.nd = new Node($$.name); $$.ASTnd = new ShiftRight($$.name); }
	| AND_ASSIGN { $$.nd = new Node($$.name); $$.ASTnd = new BitwiseAnd($$.name); }
	| XOR_ASSIGN { $$.nd = new Node($$.name); $$.ASTnd = new BitwiseXor($$.name); }
	| OR_ASSIGN { $$.nd = new Node($$.name); $$.ASTnd = new BitwiseOr($$.name); }
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
		
		VarConst* temp = dynamic_cast<VarConst*>($1.ASTnd);
		Datatype dt = temp->getDatatypeNd()->getDatatype();
		bool isConst = temp->getIsConst();
		insertVariable($2.name, dt, isConst, false);
	}
	| var_const IDENTIFIER '=' assignment ';' {
		$$.nd = new Node("declaration");
		$$.nd->insert($1.nd);
		$$.nd->insert(new Node($2.name));
		$$.nd->insert(new Node("="));
		$$.nd->insert($4.nd);
		$$.nd->insert(new Node(";"));
		$$.ASTnd = new Declaration("declaration", 
		dynamic_cast<VarConst*>($1.ASTnd), $2.name, true);
		$$.ASTnd->insert($4.ASTnd);

		VarConst* temp = dynamic_cast<VarConst*>($1.ASTnd);
		Datatype dt = temp->getDatatypeNd()->getDatatype();
		bool isConst = temp->getIsConst();
		insertVariable($2.name, dt, isConst, true);	
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

MIF 
  : IF '(' expression ')' MIF ELSE MIF {
    $$.nd = new Node("MIF");
    $$.nd->insert(new Node("if"))->insert(new Node("("))->insert($3.nd);
    $$.nd->insert(new Node(")"))->insert($5.nd)->insert(new Node("else"))->insert($7.nd);
		
    $$.ASTnd = new Mif("MIF");
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
		
		$$.ASTnd = new Uif("UIF");
		$$.ASTnd->insert($3.ASTnd)->insert($5.ASTnd);
  }
  | IF '(' expression ')' MIF ELSE UIF {
    $$.nd = new Node("UIF");
    $$.nd->insert(new Node("if"))->insert(new Node("("))->insert($3.nd);
    $$.nd->insert(new Node(")"))->insert($5.nd)->insert(new Node("else"))->insert($7.nd);
		
		$$.ASTnd = new Mif("UIF");
		$$.ASTnd->insert($3.ASTnd)->insert($5.ASTnd)->insert($7.ASTnd);
  }
  ;

start_block 
	: '{' { 
		$$.nd = new Node("{"); 
		gSymbolTable = new SymbolTable(gSymbolTable, wr_fd);
	}
	;
end_block 
	: '}' { 
		$$.nd = new Node("}"); 
		SymbolTable* temp = gSymbolTable;
		gSymbolTable = gSymbolTable->getPrev();
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




switch_body
  : CASE constant ':' block BREAK ';' switch_body {
		$$.nd = new Node("labeled_stmt"); 
		$$.nd->insert(new Node("case")); 
		$$.nd->insert(new Node($2.name)); 
		$$.nd->insert(new Node(":")); 
		$$.nd->insert($4.nd);
		$$.nd->insert(new Node("break")); 
		$$.nd->insert(new Node(";")); 
		$$.nd->insert($7.nd);
		$$.ASTnd = new Case("case");
		$$.ASTnd->insert($2.ASTnd)->insert($4.ASTnd)->insert($7.ASTnd);
	}
	| DEFAULT ':' block BREAK ';' {
		$$.nd = new Node("labeled_stmt"); 
		$$.nd->insert(new Node("default")); 
		$$.nd->insert(new Node(":")); 
		$$.nd->insert($3.nd); 
		$$.nd->insert(new Node("break")); 
		$$.nd->insert(new Node(";")); 
		$$.ASTnd = new Default("default");
		$$.ASTnd->insert($3.ASTnd);
	}

switch
	: SWITCH '(' identifier ')' start_block switch_body end_block {
		$$.nd = new Node("switch"); 
		$$.nd->insert(new Node("("));
		$$.nd->insert(new Node($3.name));
		$$.nd->insert(new Node(")"));
		$$.nd->insert(new Node("{"));
		$$.nd->insert($6.nd);
		$$.nd->insert(new Node("}"));
		$$.ASTnd = new Switch("switch");
		$$.ASTnd->insert($3.ASTnd)->insert($6.ASTnd);
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
		$$.ASTnd = new While("while");
		$$.ASTnd->insert($3.ASTnd)->insert($5.ASTnd);
	}
	| DO block WHILE '(' expression ')' ';' {
		$$.nd = new Node("loop"); 
		$$.nd->insert(new Node("do"));
		$$.nd->insert($2.nd);
		$$.nd->insert(new Node("while"));
		$$.nd->insert(new Node("("));
		$$.nd->insert($5.nd);
		$$.nd->insert(new Node(")"));
		$$.nd->insert(new Node(";"));
		$$.ASTnd = new DoWhile("DoWhile");
		$$.ASTnd->insert($2.ASTnd)->insert($5.ASTnd);
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
		$$.ASTnd = new For("for");
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

/**
* Destructor function for parser to clean up any allocation.
*/
void 
yydtor () {
	delete gSymbolTable;
	Node::DeleteTree(gParseTree);
	Node::DeleteTree(gAST);

	st_fd << 
	" </table>\n"
  "> ]\n"
	"}\n"
	;

	st_fd.close();
	std::cout << "[INFO]: Finish Writing symtable.dot file." << std::endl;
	wr_fd.close();
	std::cout << "[INFO]: Finish Writing warnings.txt file." << std::endl;
	er_fd.close();
	std::cout << "[INFO]: Finish Writing errors.txt file." << std::endl;
}

/**
* Constructor function for parser.
*/
void 
yyctor (void) {
	std::cout << "[INFO]: Start Writing symtable.dot file..." << std::endl;
	
	st_fd.open("symtable.dot");
	st_fd << 
	"digraph {\n"
  "node [ shape=none fontname=Helvetica ]\n"

  "n [ label = <\n"
    "<table>\n"
		"<tr>\n"
			"<td bgcolor='#ffcccc'>name</td>\n"
			"<td bgcolor='#ffcccc'>scope</td>\n"
			"<td bgcolor='#ffcccc'>line</td>\n"
			"<td bgcolor='#ffcccc'>type</td>\n"
			"<td bgcolor='#ffcccc'>other</td>\n"
		"</tr>\n"
	;

	std::cout << "[INFO]: Start Writing warnings.txt file..." << std::endl;
	wr_fd.open("warnings.txt");
	std::cout << "[INFO]: Start Writing errors.txt file..." << std::endl;
	er_fd.open("errors.txt");
}

Node* getParseTree ()
{
	return gParseTree;
}

Node* getAST ()
{
	return gAST;
}

void 
insertVariable(string name, Datatype dt, bool isConst, bool isInitialized)
{
	std::ostringstream buffer;
	// Lookup the symbol table, if exist return symantic error (redefinition)
	Symbol* sym = gSymbolTable->LookUp(name);
	if(NULL != sym && sym->getScope() == gSymbolTable->getLevel()) {
		buffer << "[ERROR]: @ line " << line << " " << name << " redefinition" << std::endl;
		throw buffer.str();
	} 
	// otherwise, add it to the symbol table
	else {
		sym = new VarSymbol(name, gSymbolTable->getLevel(), line, dt, isConst, isInitialized);
		gSymbolTable->insert(name, sym);
		sym->print(st_fd);
	}
}

std::ofstream& getErrorFd () {
	return er_fd;
}
/* ------------------------------------------------------------------------- */

/* ------------------------------------------------------------------------- */
/* ---------------------------- END subroutines ---------------------------- */
/* ------------------------------------------------------------------------- */

/* ------------------------------- END FILE ------------------------------- */
