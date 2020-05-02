#include <stdio.h>

extern int ghdl_main(int argc, void** argv);

int main(int argc, void** argv) {
  printf("Hello main!\n");
  printf("ghdl_main: %d\n", ghdl_main(argc, argv));
  return 0;
}
