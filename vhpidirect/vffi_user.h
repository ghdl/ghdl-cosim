#ifndef VFFI_TYPES_H
#define VFFI_TYPES_H

#include <stddef.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include <vhpi_user.h>

// Range/bounds of a dimension of an unconstrained array with dimensions of type 'natural'
typedef struct {
  int32_t left;
  int32_t right;
  int32_t dir;
  int32_t len;
} range_t;

// Unconstrained array with dimensions of type 'natural'
typedef struct {
  void*    data;
  range_t* bounds;
} vffiNaturalDimArr_t;

// Convert a fat pointer of an unconstrained string, to a (null terminated) C string
char* vffiNullTerminatedString(
  vffiNaturalDimArr_t* ptr
) {
  assert(ptr != NULL);
  assert(ptr->bounds != NULL);
  int len = ptr->bounds[0].len;
  char* str = malloc(sizeof(char) * len + 1);
  strncpy(str, ptr->data, len);
  str[len] = '\0';
  return str;
}

// Convert a fat pointer of an uncontrained array with dimensions of type 'natural', to C types
void vffiNaturalDimArrGet(
  vffiNaturalDimArr_t* ptr,
  void** vec,
  int* len,
  int num
) {
  assert(ptr != NULL);
  range_t* bounds = ptr->bounds;
  assert(bounds != NULL);
  *vec = ptr->data;
  for (int i=0; i<num; i++) {
    len[num-1-i] = bounds[i].len;
  }
}

#endif
