#include <assert.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

void default_plot (int* x, int* y, int l) {
  printf("default_plot!\n");
};

void (*plot)(int*, int*, int) = &default_plot;

int c_main(int argc, void** argv) {
  printf("Hello main %d!\n", argc);

  printf("plot is %p\n", (void*)plot);
  assert(plot != NULL);

  int32_t l = 10;
  int32_t *x = malloc(l*sizeof(int32_t));
  int32_t *y = malloc(l*sizeof(int32_t));
  int i;
  for ( i=0 ; i<l ; i++ ) {
    x[i] = 11*i;
    y[i] = 5*i*i;
  }

  plot(x, y, l);

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
