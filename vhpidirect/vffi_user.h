#ifndef VFFI_TYPES_H
#define VFFI_TYPES_H

#include <stddef.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include <vhpi_user.h>


/*
*  std_logic
*/

static const char std_logic_char[] = { 'U', 'X', '0', '1', 'Z', 'W', 'L', 'H', '-'};
enum std_logic_states {
  HDL_U = vhpiU,         /* uninitialized */
  HDL_X = vhpiX,         /* unknown */
  HDL_0 = vhpi0,         /* forcing 0 */
  HDL_1 = vhpi1,         /* forcing 1 */
  HDL_Z = vhpiZ,         /* high impedance */
  HDL_W = vhpiW,         /* weak unknown */
  HDL_L = vhpiL,         /* weak 0 */
  HDL_H = vhpiH,         /* weak 1 */
  HDL_D = vhpiDontCare   /* don't care */
};


/*
*  Fat pointer types
*/

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

// Access to an unconstrained array with 1 dimension of type 'natural'
typedef struct {
  range_t* range;
  uint8_t  data[];
} vffiNaturalDimArrAccess_t;


/*
*  Convert fat pointers to C types
*/

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

// Convert a fat pointer of an access to an unconstrained string, to a (null terminated) C string
char* vffiNullTerminatedStringAccess(
  vffiNaturalDimArrAccess_t *ptr
) {
  char *string = malloc(ptr->range[0].len + 1);
  strncpy(string, ptr->data, ptr->range[0].len);
  string[ptr->range[0].len] = '\0';
}


/*
*  Array of std_logic to/from array of bits
*/

// Compress an array of std_logic to an array of bits (8 times smaller)
void vfficharArr2bitArr(
  char* din,
  unsigned char* dout,
  int blen
) {
  for (int i = 0; i < blen; i++) {
    char d = 1;
    for (int y = 0; y < 8; y++) {
      if ((*din == HDL_1) || (*din == HDL_H)) {
        *dout |= d;
      } else {
        *dout &= ~(d);
      }
      d<<=1;
      din++;
    }
    dout++;
  }
  return;
}

// Extract an array of bits to an array of std_logic (8 times larger)
void vffibitArr2charArr(
  unsigned char* din,
  char* dout,
  int blen
) {
  for (int i = 0; i < blen; i++) {
    char d = *din;
    for (int y = 0; y < 8; y++) {
      *dout++ = (d & 1 == 1) ? HDL_1 : HDL_0;
      d>>=1;
    }
    din++;
  }
  return;
}

#endif
