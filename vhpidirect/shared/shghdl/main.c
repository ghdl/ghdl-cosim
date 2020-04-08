#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, void** argv) {

  void* h = dlopen("./tb.so", RTLD_LAZY);
  if (!h){
    fprintf(stderr, "%s\n", dlerror());
    exit(1);
  }


  typedef int print_t(char* str);

  print_t* print_something = (print_t*)dlsym(h, "print_something");
  if (!print_something){
    fprintf(stderr, "%s\n", dlerror());
    exit(2);
  }

  print_something("Hello Something!");


  typedef int main_t(int, void**);

  for (size_t i = 0; i < 3; i++) {

    main_t* ghdl_main = (main_t*)dlsym(h, "ghdl_main");
    if (!ghdl_main){
      fprintf(stderr, "%s\n", dlerror());
      exit(2);
    }

    printf("ghdl_main return: %d\n", ghdl_main(argc, argv));

    dlclose(h);

    if (i<2) {
      h = dlopen("./tb.so", RTLD_LAZY);
      if (!h){
        fprintf(stderr, "%s\n", dlerror());
        exit(1);
      }
    }

  }

  return 0;

}
