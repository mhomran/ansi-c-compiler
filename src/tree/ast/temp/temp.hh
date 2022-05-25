/**
 * @file temp.hh
 * @author Mohamed Hassanin Mohamed
 * @brief Temp class to generate unique labels specially for temporary vars.
 * @version 0.1
 * @date 2022-05-20
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include <string>
using namespace std;

class Temp {
  static int id;

  public:
  static string generateTemp();
};