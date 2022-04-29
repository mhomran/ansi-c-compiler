/**
@file: lexer.l
@brief: A lexer for ANSI C language
@author: Mohamed Hassanin
*/

/* ------------------------------------------------------------------------- */
/* --------------------------- LEX Definitions ----------------------------- */
/* ------------------------------------------------------------------------- */

/* ------------------------- Tokens Definitions ---------------------------- */
L [a-zA-Z_]

/* Integer Constant */
INTEGER_CONSTANT  ({DEC_CONST}|{OCT_CONST}|{HEX_CONST}){INTEGER_SUFFIX}?
DIGIT             [0-9]
DEC_CONST         (0|[1-9]{DIGIT}*)
OCT               [0-7]
OCT_CONST         0{OCT}+
HEX               [a-fA-F0-9]
HEX_CONST         0[xX]{HEX}+
INTEGER_SUFFIX    [ulUS]

/* Floating point constant */
FLOATING_CONSTANT   {FLOATING_CONSTANT1}|{FLOATING_CONSTANT2}
FLOATING_CONSTANT1  ({FRACTIONAL_CONSTANT}{EXPONENT_PART}?{FLOATING_SUFFIX}?)
FLOATING_CONSTANT2  ({DIGIT_SEQ}{EXPONENT_PART}{FLOATING_SUFFIX}?)
FRACTIONAL_CONSTANT (({DIGIT_SEQ}?\.{DIGIT_SEQ})|({DIGIT_SEQ}\.))
EXPONENT_PART       ([Ee]{SIGN}?{DIGIT}+)
SIGN                [+-]
DIGIT_SEQ           {DIGIT}+
FLOATING_SUFFIX     [flFL]
/* ------------------------------------------------------------------------- */

%{
/* ------------------------------- Includes -------------------------------- */
#include <cstring>
#include "parser.hh"
/* ------------------------------------------------------------------------- */

/* -------------------------- global variables ----------------------------- */
int line = 1;
int column = 0;
/* ------------------------------------------------------------------------- */

/* ------------------------- Functions prototypes -------------------------- */
void yyerror(char const *s);

void echo(const char* lexeme);
void comment(void);
/* ------------------------------------------------------------------------- */
%}

/* ------------------------------------------------------------------------- */
/* ------------------------- END LEX Definitions --------------------------- */
/* ------------------------------------------------------------------------- */
%%
 /* ------------------------------------------------------------------------- */
 /* ------------------------------- LEX Rules ------------------------------- */
 /* ------------------------------------------------------------------------- */

 /* ------------------------------- Comments -------------------------------- */
"/*"                                    { comment(); }
 /* ------------------------------------------------------------------------- */

 /* --------------------------- Reserved keywords --------------------------- */
 /* If-then-else statement */
"if"        { echo("if"); return(IF); }
"else"      { echo("else"); return(ELSE); }
 /* while, repeat-until, for loops */
"do"        { echo("do"); return(DO); }
"while"     { echo("while"); return(WHILE); }
"for"       { echo("for"); return(FOR); }
"continue"  { echo("continue"); return(CONTINUE); }
"break"     { echo("break"); return(BREAK); }
 /* switch statement */
"switch"    { echo("switch"); return(SWITCH); }
"case"      { echo("case"); return(CASE); }
"default"   { echo("default"); return(DEFAULT); }
":"         { echo(":"); return(':'); }
 /* data types */
"void"      { echo("void"); return(VOID); }
"char"      { echo("char"); return(CHAR); }
"short"     { echo("short"); return(SHORT); }
"int"       { echo("int"); return(INT); }
"long"      { echo("long"); return(LONG); }
"float"     { echo("float"); return(FLOAT); }
"double"    { echo("double"); return(DOUBLE); }
 /* constants */
"const"     { echo("const"); return(CONST); }
 /* functions */
"return"    { echo("return"); return(RETURN); }
","         { echo(","); return(','); }
 /* ------------------------------------------------------------------------- */

 /* ------------------------ Variables and Constants ------------------------ */
 /* Identifiers */
{L}({L}|{DIGIT})*     { 
	strcpy(yylval.TreeNode.name, yytext); 
	echo("identifier"); 
	return(IDENTIFIER); 
}
 
 /* integer Constant */
{INTEGER_CONSTANT}    { echo("integer_constant"); return(CONSTANT); }
 /* Floating Constant */
{FLOATING_CONSTANT}   { echo("floating_constant"); return(CONSTANT); }
 /* Char Constant (simplified) */
'([a-zA-Z]|{DIGIT})'  { echo("char"); return(CONSTANT); }			
 
 /* string literals */
 /* L?"(escaped char or char which is not quote or a backslash)" */
L?\"(\\.|[^\\"])*\"   { echo("string_literal"); return(STRING_LITERAL); }
 /* ------------------------------------------------------------------------- */

 /* ------------------------- Assignment statements ------------------------- */
 
"++"    { strcpy(yylval.TreeNode.name, yytext); echo("++"); return(INC_OP); }
"--"    { strcpy(yylval.TreeNode.name, yytext); echo("--"); return(DEC_OP); }
">>="   { strcpy(yylval.TreeNode.name, yytext); echo(">>="); return(RIGHT_ASSIGN); }
"<<="   { strcpy(yylval.TreeNode.name, yytext); echo("<<="); return(LEFT_ASSIGN); }
"+="    { strcpy(yylval.TreeNode.name, yytext); echo("+="); return(ADD_ASSIGN); }
"-="    { strcpy(yylval.TreeNode.name, yytext); echo("-="); return(SUB_ASSIGN); }
"*="    { strcpy(yylval.TreeNode.name, yytext); echo("*="); return(MUL_ASSIGN); }
"/="    { strcpy(yylval.TreeNode.name, yytext); echo("/="); return(DIV_ASSIGN); }
"%="    { strcpy(yylval.TreeNode.name, yytext); echo("%="); return(MOD_ASSIGN); }
"&="    { strcpy(yylval.TreeNode.name, yytext); echo("&="); return(AND_ASSIGN); }
"^="    { strcpy(yylval.TreeNode.name, yytext); echo("^="); return(XOR_ASSIGN); }
"|="    { strcpy(yylval.TreeNode.name, yytext); echo("|="); return(OR_ASSIGN); }
"="     { strcpy(yylval.TreeNode.name, yytext); echo("="); return('='); }
 /* ------------------------------------------------------------------------- */

 /* ------------------- Relational and Equality Operators ------------------- */
"<="    { echo("<="); return(LE_OP); }
">="    { echo(">="); return(GE_OP); }
"=="    { echo("=="); return(EQ_OP); }
"!="    { echo("!="); return(NE_OP); }
"<"	    { echo("<"); return('<'); }
">"	    { echo(">"); return('>'); }
 /* ------------------------------------------------------------------------- */

 /* ------------------------------- Semicolon ------------------------------- */
";"			{ echo(";"); return(';'); }
 /* ------------------------------------------------------------------------- */

 /* ------------------------------ Punctuators ------------------------------ */
"["     { echo("["); return('['); }
"]"     { echo("]"); return(']'); }
"("     { echo("("); return('('); }
")"     { echo(")"); return(')'); }
"{"     { echo("{"); return('{'); }
"}"     { echo("}"); return('}'); }
 /* ------------------------------------------------------------------------- */

 /* ----------------- Mathematical and logical expressions ------------------ */
 /* Logical */
"&&"    { echo("&&"); return(AND_OP); }
"||"    { echo("||"); return(OR_OP); }
"!"     { echo("!"); return('!'); }
 /* bit-wise */
"&"     { echo("&"); return('&'); }
"|"     { echo("|"); return('|'); }
"~"     { echo("~"); return('~'); }
"^"     { echo("^"); return('^'); }
">>"    { echo(">>"); return(RIGHT_OP); }
"<<"    { echo("<<"); return(LEFT_OP); }
 /* Arithmetic */
"-"     { echo("-"); return('-'); }
"+"     { echo("+"); return('+'); }
"*"     { echo("*"); return('*'); }
"/"     { echo("/"); return('/'); }
"%"     { echo("%"); return('%'); }
 /* ------------------------------------------------------------------------- */

 /* ----------------------------- White spaces ------------------------------ */
[ \t\v\f] { echo("white_space"); }
[\n\r]    { echo("white_space"); line++; }
.         { echo("bad_char"); }
 /* ------------------------------------------------------------------------- */

 /* ------------------------------------------------------------------------- */
 /* ----------------------------- END LEX Rules ----------------------------- */
 /* ------------------------------------------------------------------------- */
%%
 /* ------------------------------------------------------------------------- */
 /* ------------------------------ subroutines ------------------------------ */
 /* ------------------------------------------------------------------------- */

 /* ------------------------- Functions Definitions ------------------------- */


int yywrap()
{
	return(1);
}

void comment(void)
{
	char c;
	int state = 0;
	int IsTemrinated = 0;

	while (!IsTemrinated && ((c = yyinput()) != 0))
	{
		switch(state) 
		{
			case 0:
			if(c == '*') {
				state = 1;
			}
			else {
				if(c == '\n') line++;
				state = 0;
			} 
			break;
			
			case 1:
			if(c == '/'){
				state = 2;
				IsTemrinated = 1;
			} 
			else if (c == '*') {
				state = 1;
			}
			else {
				if(c == '\n') line++;
				state = 0;
			}
			break;

			default:
			//unreachable
			break; 
		}
	}
	
	if(!IsTemrinated) yyerror("[ERROR]: unterminated comment\n");
}

void echo(const char* lexeme)
{
	int i;

	//Update the column pointer
	for (i = 0; yytext[i] != '\0'; i++)
		if (yytext[i] == '\n')
			column = 0;
		else if (yytext[i] == '\t')
			column += 8 - (column % 8);
		else
			column++;

	ECHO; // print the text matched with the pattern
	/* printf("\nline: %d %t,%t lexeme: %s %t,%t token: %s\n", line, lexeme, yytext); */
}

 /* ------------------------------------------------------------------------- */

 /* ------------------------------------------------------------------------- */
 /* ---------------------------- END subroutines ---------------------------- */
 /* ------------------------------------------------------------------------- */

 /* ------------------------------- END FILE ------------------------------- */