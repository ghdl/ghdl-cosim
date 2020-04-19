#include <stdlib.h>
#include <stdio.h>

extern int ghdl_main(int argc, void** argv);

// Procedure to be executed when GHDL exits.
static void exit_handler(void) {
  printf("This is the exit handler.\n");
}

int wrapper(int argc, void** argv) {
  atexit(exit_handler);

  printf("Hello wrapper!\n");
  printf("ghdl_main: %d\n", ghdl_main(argc, argv));
  printf("Bye wrapper!\n");

  return 0;
}
