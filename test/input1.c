/**
 * @file input1.c
 * @author Mohamed Hassanin
 * @brief This is a test file for most of the recognized syntax
 * without any warnings and errors.
 * @version 0.1
 * @date 2022-04-22
 * 
 * @copyright Copyright (c) 2022
 * 
 */

/* -------------------------- global variables ----------------------------- */
int a = 5;
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
    const int x = 1;
    int y = 1;
    int looper1 = 1;
    float z = 1;
    
    int a1 = 1; int a2 = 1; int a3 = 1; int a4 = 1;

    /* Char */
    int c = 'c';
    c = c + x;
    
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
    z = z > y;
    z = z < z;
    z = z <= z;
    z = z >= z;
    z = z == z;
    z = z != z;
    z = !z;
    z = (a1 < a2) && (a3 || a4);

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
            if(y == z) a = a;
        }
        break;
    }

    /* blocks */
    {
        float a = 2;
        a = 1 + a;
    }
    
    /* Function Calls 
    yoo();
    foo(x, y, z); */

    /* expressions */
    a = (a1 + a2) * a3 / a4;

    return 0;
}

/* ------------------------------------------------------------------------- */
