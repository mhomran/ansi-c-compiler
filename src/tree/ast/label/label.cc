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
  static int id = -1;
  
  id++;
  return id;
}
