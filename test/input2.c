/**
 * @file input2.c
 * @author Mohamed Hassanin Mohamed
 * @brief This is a test file for warnings.
 * @version 0.1
 * @date 2022-04-27
 * 
 * @copyright Copyright (c) 2022
 * 
 */

const int a; /* uninitalized */
const int b; /* uninitalized + unused */
int main(int a) {
  const int a; /* Shadowing + uninitalized + unused */
  {
    int a; /* another shadowing + uninitialized + used */
    a = a + 2; 
  }
}
