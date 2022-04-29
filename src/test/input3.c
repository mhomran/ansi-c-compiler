int x;
int y;
void f(int x, int a) {
  int b;
  y = x+ a*b;
  if(y < 5) {
    int a;
    y = x + a*b;
  }
  y = x + a*b;
  a *= a;
  switch(a){
    case 1: {
      a *= a;
    }
    break;
    default: {
      a *= a;
    }
    break;
  }
}