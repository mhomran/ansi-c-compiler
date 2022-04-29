/**
 * @file input1.c
 * @author Mohamed Hassanin
 * @brief This is a test file to test my ANSI C parser and lexer.
 * @version 0.1
 * @date 2022-04-22
 * 
 * @copyright Copyright (c) 2022
 * 
 */

/* -------------------------- global variables ----------------------------- */
int a;
/* ------------------------------------------------------------------------- */

/* ------------------------- Functions prototypes -------------------------- */
int foo(int a, int b, int c);
int yoo(void);
/* ------------------------------------------------------------------------- */

/* ------------------------- Functions Definitions ------------------------- */

/**
 * @brief yoo yoo yoo
 * 
 * @return int 
 */
int 
yoo(void)
{
    return 2022;
}

int yooHey() {
    return 2022;
}

int 
main(void) {
    /* ------------------------- 
    Local Variables declaration 
    ------------------------- */
    const int x;
    int y;
    int looper1, looper2;
    float z;
    const int x_init = 2022;
    int y_init = 2022;
    float z_init = 2022;
    
    /* Char */
    int c = 'c';
    
    /* ------------------------- 
    Business logic
    ------------------------- */
    
    /* Floating numbers */
    z=.3;
    z=3.3;
    z=3e1;
    z=3.3e1;
    z=.3e1;

    /* Bitwise operators */
    y |= y;
    y = y | y;
    y &= y;
    y = y & y;
    y ^= y;
    y = y ^ y;
    y = ~y;

    /* conditional operators */
    y = y > y;
    y = y < y;
    y = y <= y;
    y = y >= y;
    y = y == y;
    y = y != y;
    y = !y;

    /* Arithmetic operators */
    y = y + y;
    y = y - y;
    y = y * y;
    y = y / y;
    y = y % y;
    y = (y + y) * y / y;

    /* if-else-else if */
    if (y != y) y = 4;
    
    if (y != y) { y = 4; }
    else { y = 2;}

    if (y != y) { y = 4; }
    else if(y == y) { y == 4;}
    
    if (y != y) { y = 4; }
    else if(y == y) { y == 4;}
    else { y = 2;}

    /* loops */
    for(looper1 = 0; looper1 < 4; looper1++) {
        looper1;
    }
    looper1 = 0;
    while(looper1 < 4){
        looper1;
        looper1++;
    }
    looper1 = 0;
    do{
        looper1;
        looper1++;
    } while(!(looper1 >= 4));

    /* switch statement */
    switch(a){
        case 0: {
            if(a == a) a = a;
            if(a == a) a = a;
        }
        break;

        default: {
            /* DO NOTHING */
        }
        break;
    }

    /* blocks */
    {
        int a;
        a = 1;
    }
    
    /* Function Calls */
    yoo();
    foo(x, y, z);

    /* expressions */
    a = (a + a) * a / a;
}
/* ------------------------------------------------------------------------- */
