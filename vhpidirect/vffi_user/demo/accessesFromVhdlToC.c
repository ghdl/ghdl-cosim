#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#include <assert.h>
#include <string.h>

#include <vffi_user.h>

// GitHub Actions collapsible/expandable groups
void ghaGStart(char* str) {
  printf("::group::%s\n", str);
  //printf("· %s\n", str);
}

void ghaGEnd() {
  printf("::endgroup::\n");
  //printf("\n");
}

// Function to be called from VHDL as a foreign subprogram
void passAccessesFromVhdlToC(
  vffiNaturalDimArr_t* v_natural1D_int
) {

  int* len = malloc(2 * sizeof(int));

  ghaGStart("Unconstrained natural 1D array of Integer");
  vhpiIntT* vec1D_int;
  vffiNaturalDimArrGet(v_natural1D_int, (void**)&vec1D_int, len, 1);
  printf("vec1D_int  : %p [%d]\n", vec1D_int, len[0]);
  assert(vec1D_int[0] == 11);
  assert(vec1D_int[1] == 22);
  assert(vec1D_int[2] == 33);
  assert(vec1D_int[3] == 44);
  assert(vec1D_int[4] == 55);
  ghaGEnd();

}
