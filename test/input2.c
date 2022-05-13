/**
 * @file input2.c
 * @author Mohamed Hassanin Mohamed
 * @brief This is a test file to test my ANSI C parser and lexer.
 * @version 0.1
 * @date 2022-04-27
 * 
 * @copyright Copyright (c) 2022
 * 
 */

const int a; /* uninitalized */
const int b; /* uninitalized */
int main() {
  const int a; /* Shadowing + uninitalized */
  {
    int a = 2; /* another shadowing + initialized + used */
    a = b + 2;
    a = a + 2;
    a = c + 2; /* undefined */
  }
}
