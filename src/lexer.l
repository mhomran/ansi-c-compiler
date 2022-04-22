/**
@file: lexer.l
@brief: A lexer for ANSI C language
@author: Mohamed Hassanin
*/

/* ------------------------------------------------------------------------- */
/* --------------------------- LEX Definitions ----------------------------- */
/* ------------------------------------------------------------------------- */

/* ------------------------- Tokens Definitions ---------------------------- */
L			[a-zA-Z_]

/* Integer Constant */
INTEGER_CONSTANT	({DEC_CONST}|{OCT_CONST}|{HEX_CONST}){INTEGER_SUFFIX}?
DIGIT			[0-9]
DEC_CONST 		(0|[1-9]{DIGIT}*)
OCT			[0-7]
OCT_CONST		0{OCT}+
HEX			[a-fA-F0-9]
HEX_CONST		0[xX]{HEX}+
INTEGER_SUFFIX		[ulUS]

/* Floating point constant */
FLOATING_CONSTANT 	{FLOATING_CONSTANT1}|{FLOATING_CONSTANT2}
FLOATING_CONSTANT1 	({FRACTIONAL_CONSTANT}{EXPONENT_PART}?{FLOATING_SUFFIX}?)
FLOATING_CONSTANT2	({DIGIT_SEQ}{EXPONENT_PART}{FLOATING_SUFFIX}?)
FRACTIONAL_CONSTANT	(({DIGIT_SEQ}?\.{DIGIT_SEQ})|({DIGIT_SEQ}\.))
EXPONENT_PART		([Ee]{SIGN}?{DIGIT}+)
SIGN                    [+-]
DIGIT_SEQ               {DIGIT}+
FLOATING_SUFFIX         [flFL]
/* ------------------------------------------------------------------------- */

%{
/* ------------------------------- Includes -------------------------------- */
#include <stdio.h>
#include "parser.h"
/* ------------------------------------------------------------------------- */

/* -------------------------- global variables ----------------------------- */
int line = 1;
int column = 0;
/* ------------------------------------------------------------------------- */

/* ------------------------- Functions prototypes -------------------------- */
void count(char* lexeme);
void yyerror(char const *s);
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
"if"			{ count("if"); return(IF); }
"else"			{ count("else"); return(ELSE); }
 /* while, repeat-until, for loops */
"do"			{ count("do"); return(DO); }
"while"			{ count("while"); return(WHILE); }
"for"			{ count("for"); return(FOR); }
"continue"		{ count("continue"); return(CONTINUE); }
"break"			{ count("break"); return(BREAK); }
 /* switch statement */
"switch"		{ count("switch"); return(SWITCH); }
"case"			{ count("case"); return(CASE); }
"default"		{ count("default"); return(DEFAULT); }
":"			{ count(":"); return(':'); }
 /* data types */
"void"			{ count("void"); return(VOID); }
"char"			{ count("char"); return(CHAR); }
"short"			{ count("short"); return(SHORT); }
"int"			{ count("int"); return(INT); }
"long"			{ count("long"); return(LONG); }
"float"			{ count("float"); return(FLOAT); }
"double"		{ count("double"); return(DOUBLE); }
 /* constants */
"const"			{ count("const"); return(CONST); }
 /* functions */
"return"		{ count("return"); return(RETURN); }
","			{ count(","); return(','); }
 /* ------------------------------------------------------------------------- */

 /* ------------------------ Variables and Constants ------------------------ */
 /* Identifiers */
{L}({L}|{DIGIT})*		{ count("identifier"); return(IDENTIFIER); }
 
 /* integer Constant */
{INTEGER_CONSTANT}		{ count("integer_constant"); return(CONSTANT); }
 /* Floating Constant */
{FLOATING_CONSTANT}		{ count("floating_constant"); return(CONSTANT); }
 /* Char Constant (simplified) */
'([a-zA-Z]|{DIGIT})'		{ count("char"); return(CONSTANT); }			
 
 /* string literals */
 /* L?"(escaped char or char which is not quote or a backslash)" */
L?\"(\\.|[^\\"])*\"		{ count("string_literal"); return(STRING_LITERAL); }
 /* ------------------------------------------------------------------------- */

 /* ------------------------- Assignment statements ------------------------- */
 
"++"			{ count("++"); return(INC_OP); }
"--"			{ count("--"); return(DEC_OP); }
">>="			{ count(">>="); return(RIGHT_ASSIGN); }
"<<="			{ count("<<="); return(LEFT_ASSIGN); }
"+="			{ count("+="); return(ADD_ASSIGN); }
"-="			{ count("-="); return(SUB_ASSIGN); }
"*="			{ count("*="); return(MUL_ASSIGN); }
"/="			{ count("/="); return(DIV_ASSIGN); }
"%="			{ count("%="); return(MOD_ASSIGN); }
"&="			{ count("&="); return(AND_ASSIGN); }
"^="			{ count("^="); return(XOR_ASSIGN); }
"|="			{ count("|="); return(OR_ASSIGN); }
"="			{ count("="); return('='); }
 /* ------------------------------------------------------------------------- */

 /* ------------------- Relational and Equality Operators ------------------- */
"<="			{ count("<="); return(LE_OP); }
">="			{ count(">="); return(GE_OP); }
"=="			{ count("=="); return(EQ_OP); }
"!="			{ count("!="); return(NE_OP); }
"<"				{ count("<"); return('<'); }
">"				{ count(">"); return('>'); }
 /* ------------------------------------------------------------------------- */

 /* ------------------------------- Semicolon ------------------------------- */
";"			{ count(";"); return(';'); }
 /* ------------------------------------------------------------------------- */

 /* ------------------------------ Punctuators ------------------------------ */
"["			{ count("["); return('['); }
"]"			{ count("]"); return(']'); }
"("			{ count("("); return('('); }
")"			{ count(")"); return(')'); }
"{"			{ count("{"); return('{'); }
"}"			{ count("}"); return('}'); }
 /* ------------------------------------------------------------------------- */

 /* ----------------- Mathematical and logical expressions ------------------ */
 /* Logical */
"&&"			{ count("&&"); return(AND_OP); }
"||"			{ count("||"); return(OR_OP); }
"!"			{ count("!"); return('!'); }
 /* bit-wise */
"&"			{ count("&"); return('&'); }
"|"			{ count("|"); return('|'); }
"~"			{ count("~"); return('~'); }
"^"			{ count("^"); return('^'); }
">>"			{ count(">>"); return(RIGHT_OP); }
"<<"			{ count("<<"); return(LEFT_OP); }
 /* Arithmetic */
"-"			{ count("-"); return('-'); }
"+"			{ count("+"); return('+'); }
"*"			{ count("*"); return('*'); }
"/"			{ count("/"); return('/'); }
"%"			{ count("%"); return('%'); }
 /* ------------------------------------------------------------------------- */

 /* ----------------------------- White spaces ------------------------------ */
[ \t\v\f]		{ count("white_space"); }
[\n\r]			{ count("white_space"); line++; }
.			{ count("bad_char"); }
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

	while (!IsTemrinated && ((c = input()) != 0))
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

void count(char* lexeme)
{
	int i;

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