#include <signal.h>
#include <stdio.h>

extern int wrapper(int argc, void** argv);

void sigabrtHandler(int sig_num) {
  // Reset handler to catch SIGABRT next time. Refer http://en.cppreference.com/w/c/program/signal
  signal(SIGABRT, sigabrtHandler);
  printf("\nSIGABRT caught %d!\n", sig_num);
  fflush(stdout);
}

int main(int argc, void** argv) {
  signal(SIGABRT, sigabrtHandler);
  return wrapper(argc, argv);
}
