#include <stdio.h>

extern int ghdl_main(int argc, void** argv);

int varInt = 5;

void setGenInt(int val) {
  varInt = val;
}

int main(int argc, void** argv) {
  printf("Hello fcngen!\n");
  ghdl_main(argc, argv);
  printf("varInt: %i\n", varInt);
}
