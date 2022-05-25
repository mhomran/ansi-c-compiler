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
int yoo();
/* ------------------------------------------------------------------------- */

/* ------------------------- Functions Definitions ------------------------- */

/**
 * @brief yoo yoo yoo
 * 
 * @return int 
 */
int 
yoo()
{
    return 2022;
}

int yooHey() {
    return 2022;
}

int 
main() {
    /* ------------------------- 
    Local Variables declaration 
    ------------------------- */
    const int x;
    int y;
    int looper1;
    float z;
    const int x_init = 2022;
    int y_init = 2022;
    float z_init = 2022;
    
    int a1; int a2; int a3; int a4; int a5;

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
    y |= a1;
    y = a1 | a2;
    y &= a3;
    y = y & y;
    y ^= y;
    y = y ^ y;
    y = ~y;

    /* conditional operators */
    z = z > z;
    z = z < z;
    z = z <= z;
    z = z >= z;
    z = z == z;
    z = z != z;
    z = !z;

    /* Arithmetic operators */
    y = z + y;
    z = z + y;
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
    for(looper1 = 0; looper1 < 4; looper1 += 1) {
        looper1;
    }
    looper1 = 0;
    while(looper1 < 4){
        looper1;
        looper1+=1;
        looper1-=9;
        looper1-=20;
    }
    looper1 = 0;
    do{
        looper1;
        looper1+=1;
    } while(!(looper1 >= 4));

    /* switch statement */
    switch(a){
        case 123: {
            if(a == a) a = a;
            if(a == a) a = a;
        }
        break;

        case 456: {
            if(a == a) a = a;
            if(a == a) a = a;
        }
        break;

        default: {
            if(a == a) a = a;
        }
        break;
    }

    /* blocks */
    {
        int a;
        a = 1;
    }
    
    /* Function Calls 
    yoo();
    foo(x, y, z); */

    /* expressions */
    a = (a1 + a2) * a3 / a4;

    return 0;
}

int real;

/* ------------------------------------------------------------------------- */
