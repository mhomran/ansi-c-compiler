/**
 * @file compiler.cc
 * @author Mohamed Hassanin Mohamed
 * @brief A compiler for C language 89 which is known as ANSI C.
 * @version 0.1
 * @date 2022-04-25
 * 
 * @copyright Copyright (c) 2022
 * 
 */

/* ------------------------------- includes -------------------------------- */
#include <iostream>
/* ------------------------------------------------------------------------- */

/* ------------------------- Functions prototypes -------------------------- */
int yyparse (void);
/* ------------------------------------------------------------------------- */

/* ------------------------- Functions Definitions ------------------------- */
int 
main(void)
{
  bool ParseError;
  int ret;
  
  ret = yyparse();
  ParseError = 0 != ret;

  if(ParseError)
    {
      std::cout << "[ERROR]: Parser Failed" << std::endl;
    }
  else
    {
      std::cout << "[INFO]: Parser Success" << std::endl;
    }
	
	return 0;
}
/* ------------------------------------------------------------------------- */