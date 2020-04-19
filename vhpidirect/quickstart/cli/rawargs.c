#include <stdio.h>

extern int ghdl_main(int argc, void** argv);

int main(int argc, void** argv) {
  printf("Hello rawargs!\n");
  ghdl_main(argc, argv);
}
