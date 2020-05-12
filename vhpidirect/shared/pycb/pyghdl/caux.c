#include <assert.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

extern int ghdl_main(int argc, void** argv);

void default_plot (int* x, int* y, int l) {
  printf("default_plot!\n");
};

void (*plot)(int*, int*, int) = &default_plot;

void ghdl_plot (int* x, int* y, int l) {
  printf("ghdl_plot!\n");
  plot(x, y, l);
};

int c_main(int argc, void** argv) {
  printf("Hello main %d!\n", argc);

  printf("plot is %p\n", (void*)plot);
  assert(plot != NULL);

  printf("ghdl_main: %d\n", ghdl_main(argc, argv));

  return 0;
}

int py_main(int argc, void** argv, void (*fptr)(int*, int*, int)) {
  printf("Hello pymain %d!\n", argc);
  if (fptr != NULL) {
    printf("fptr is %p\n", (void*)plot);
    plot = fptr;
  }
  c_main(argc, argv);
  return 0;
}
