/**
 * @file sym.cc
 * @author Mohamed Hassanin
 * @brief A data structure for the symbol in the symbol tables.
 * @version 0.1
 * @date 2022-05-12
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "sym.hh"

Symbol::Symbol(string name, int scope)
: name{name}
, scope{scope} {

}
