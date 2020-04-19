#include <assert.h>
#include <malloc.h>
#include <stddef.h>

int* allocIntArr(int arrSize){
  return malloc(arrSize*sizeof(int));
}

void initIntArr(int* ptr, int arrSize) {
  for (int i = 0; i < arrSize; i++) {
    ptr[i] = 11*(i+1);
  }
}

void checkAndPrintIntArr(int* ptr, int arrSize) {
  for (int i = 0; i < arrSize; i++) {
    printf("%d: %d\n", i, ptr[i]);
    assert(ptr[i] == -3 * 11 * (i+1));
  }
}

void freePointer(int* ptr){
  free(ptr);
}
