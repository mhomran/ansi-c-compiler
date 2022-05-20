/**
 * @file label.cc
 * @author Mohamed Hassanin Mohamed
 * @brief Label class to generate unique labels
 * @version 0.1
 * @date 2022-05-20
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "label.hh"

int Label::generateLabel() {  
  id++;
  return id;
}

int Label::getLastLabel() {
  return id;
}

int Label::id = -1;
