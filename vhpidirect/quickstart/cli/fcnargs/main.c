#include <stdio.h>

extern int ghdl_main(int argc, void** argv);

int getGenInt(void) {
  return 5;
}

int main(int argc, void** argv) {
  printf("Hello fcnargs!\n");
  ghdl_main(argc, argv);
}
