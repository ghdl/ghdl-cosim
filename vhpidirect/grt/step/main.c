#include <stdio.h>
#include <grt.h>

int main(int argc, void** argv) {
  grt_init ();
  grt_main_options (argv[0], argc, (const char * const*)argv);
  grt_main_elab ();
  __ghdl_simulation_init ();
  int ecode;
  do {
    ecode = __ghdl_simulation_step ();
    printf("ecode: %d\n", ecode);
  } while (ecode<3);
  return 0;
}
