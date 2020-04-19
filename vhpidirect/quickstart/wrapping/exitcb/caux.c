#include <stdlib.h>
#include <stdio.h>

extern int ghdl_main(int argc, void** argv);

static void exit_handler(void) {
  printf("This is the exit handler.\n");
}

int wrapper(int argc, void** argv) {
  atexit(exit_handler);

  printf("Hello wrapper!\n");
  int ecode = ghdl_main(argc, argv);
  printf("Bye wrapper <%d>!\n", ecode);

  return 0;
}
