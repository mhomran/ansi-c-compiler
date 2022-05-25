/**
 * @file temp.cc
 * @author Mohamed Hassanin Mohamed
 * @brief Temp class to generate unique labels specially for temporary vars.
 * @version 0.1
 * @date 2022-05-20
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "temp.hh"

string Temp::generateTemp() {  
  id++;
  return "T" + to_string(id);
}


int Temp::id = -1;
