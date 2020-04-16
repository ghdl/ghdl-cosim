#include <assert.h>
#include <stdint.h>
#include <stdio.h>

#define SIZE_ROWS 5
#define SIZE_COLUMNS 2

extern int ghdl_main(int argc, char** argv);

static const int8_t size[2] = { SIZE_ROWS , SIZE_COLUMNS };
double matrix[SIZE_ROWS][SIZE_COLUMNS];

int32_t getMatSize(int32_t x){
  return (int32_t)size[x];
}

uintptr_t getMatPointer(){
  return (uintptr_t)matrix;
}

int main(int argc, char** argv) {
  assert(sizeof(double)==8);
  int i, j;
  for ( i=0 ; i<size[0] ; i++ ) {
    printf("%d: ", i);
    for ( j=0 ; j<size[1] ; j++ ) {
      matrix[i][j] = 0.5 + i * 11.0 + j * 0.11;
      printf("%09.6f ", matrix[i][j]);
    }
    printf("\n");
  }
  return ghdl_main(argc, argv);
}
