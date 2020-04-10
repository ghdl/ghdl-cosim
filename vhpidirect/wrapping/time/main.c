#include <time.h>
#include <stdio.h>

extern int ghdl_main (int argc, void** argv, void** envp);

int main (int argc, void** argv, void** envp) {
  clock_t start_clock = clock ();
  clock_t t;
  int res;

  printf ("Starting GHDL simulation\n");

  res = ghdl_main (argc, argv, envp);

  t = clock () - start_clock;

  /* On POSIX, CLOCKS_PER_SEC is 1000000  */
  printf ("Simulation time: %d sec %06d usec\n",
    t / CLOCKS_PER_SEC, t % CLOCKS_PER_SEC);
  return res;
}
