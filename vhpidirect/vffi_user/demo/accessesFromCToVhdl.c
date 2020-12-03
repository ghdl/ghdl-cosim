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
void passAccessesFromCToVhdl(
) {

  printf("· passAccessesFromCToVhdl\n");

}

vffiLine_t* getLine() {
  return lineFromString("HELLO WORLD");
}
