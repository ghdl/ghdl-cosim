#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char **argv) {
  printf("> Hello, I'm your host: %ld\n", (long)getpid());

  typedef int main_t(int, char**);
  void * client_hndl;

  client_hndl = dlopen("./corea.so",  RTLD_LAZY);
  if (!client_hndl){
      fprintf(stderr, "%s\n", dlerror());
      exit(1);
  }

  main_t *A_ghdl_main = (main_t*)dlsym(client_hndl, "ghdl_main");
  if (!A_ghdl_main){
      fprintf(stderr, "%s\n", dlerror());
      exit(2);
  }

  A_ghdl_main(1, (char*[]){"client", 0});

  client_hndl = dlopen("./coreb.so",  RTLD_LAZY);
  if (!client_hndl){
      fprintf(stderr, "%s\n", dlerror());
      exit(1);
  }

  main_t *B_ghdl_main = (main_t*)dlsym(client_hndl, "ghdl_main");
  if (!B_ghdl_main){
      fprintf(stderr, "%s\n", dlerror());
      exit(2);
  }

  B_ghdl_main(1, (char*[]){"client", 0});

  return 0;
}
