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

// Struct that matches record 'rec_t' in VHDL
typedef struct rec_t {
  vhpiCharT r_char;
  vhpiIntT  r_int;
} rec_t;

// Enumeration that matches 'enum_t' in VHDL
typedef enum {standby, start, busy, done} enum_t;

// Function to be called from VHDL as a foreign subprogram
void testCinterface(
  vhpiCharT            v_char,
  vhpiIntT             v_int,
  uint32_t             v_nat,
  uint32_t             v_pos,
  vhpiRealT            v_real,
  bool                 v_bool,
  bool                 v_bit,
  int64_t              v_time,
  rec_t*               v_rec,
  vhpiSmallEnumT       v_enum,
  vhpiSmallEnumT       v_std,
  vhpiSmallEnumT*      v_stdv_downto,
  vhpiSmallEnumT*      v_stdv_to,
  vffiNaturalDimArr_t* v_str,
  vffiNaturalDimArr_t* v_natural1D_int,
  vffiNaturalDimArr_t* v_natural1D_real,
  vffiNaturalDimArr_t* v_natural1D_bool,
  vffiNaturalDimArr_t* v_natural1D_bit,
  vffiNaturalDimArr_t* v_natural1D_time,
  vffiNaturalDimArr_t* v_natural1D_rec,
  vffiNaturalDimArr_t* v_natural1D_enum,
  vffiNaturalDimArr_t* v_natural2D_real
) {

  ghaGStart("Character");
  printf("v_char : %c\n", v_char);
  assert(v_char == 'k');
  ghaGEnd();

  ghaGStart("Integer");
  printf("v_int  : %d\n", v_int);
  assert(v_int == -6);
  ghaGEnd();

  ghaGStart("Natural");
  printf("v_nat  : %d\n", v_nat);
  assert(v_nat == 9);
  ghaGEnd();

  ghaGStart("Positive");
  printf("v_pos  : %d\n", v_pos);
  assert(v_pos == 3);
  ghaGEnd();

  ghaGStart("Real");
  printf("v_real : %f\n", v_real);
  assert(v_real == 3.34);
  ghaGEnd();

  ghaGStart("Boolean");
  printf("v_bool : %d\n", v_bool);
  assert(v_bool == true);
  ghaGEnd();

  ghaGStart("Bit");
  printf("v_bit  : %d\n", v_bit);
  assert(v_bit == true);
  ghaGEnd();

  ghaGStart("Time");
  printf("v_time : %d\n", v_time);
  assert(v_time == 20e6);
  ghaGEnd();

  ghaGStart("Record");
  printf("v_rec  : %p %c %d\n", v_rec, v_rec->r_char, v_rec->r_int);
  assert(v_rec != NULL);
  assert(v_rec->r_char == 'y');
  assert(v_rec->r_int == 5);
  ghaGEnd();

  ghaGStart("Enumeration");
  printf("v_enum : %d %d\n", v_enum, busy);
  assert(v_enum == busy);
  ghaGEnd();

  ghaGStart("std_logic");
  printf("v_std : %d [%c] %d [%c]\n", v_std, std_logic_char[v_std], HDL_Z, std_logic_char[HDL_Z]);
  assert(v_std == HDL_Z);
  ghaGEnd();

  ghaGStart("std_logic_vector (downto)");
  printf("v_stdv_downto : %p\n", v_stdv_downto);
  assert(v_stdv_downto[0] == HDL_L);
  assert(v_stdv_downto[1] == HDL_X);
  assert(v_stdv_downto[2] == HDL_Z);
  assert(v_stdv_downto[3] == HDL_1);
  ghaGEnd();

  ghaGStart("std_logic_vector (to)");
  printf("v_stdv_to : %p\n", v_stdv_to);
  assert(v_stdv_to[0] == HDL_L);
  assert(v_stdv_to[1] == HDL_X);
  assert(v_stdv_to[2] == HDL_Z);
  assert(v_stdv_to[3] == HDL_1);
  ghaGEnd();

  ghaGStart("String");
  char* str = vffiNullTerminatedString(v_str);
  printf("v_str  : %p '%s' [%d]\n", v_str->data, str, strlen(str));
  assert(strcmp(str, "hellostr") == 0);
  ghaGEnd();

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

  ghaGStart("Unconstrained natural 1D array of Real");
  vhpiRealT* vec1D_real;
  vffiNaturalDimArrGet(v_natural1D_real, (void**)&vec1D_real, len, 1);
  printf("vec1D_real : %p [%d]\n", vec1D_real, len[0]);
  assert(vec1D_real[0] == 0.5);
  assert(vec1D_real[1] == 1.75);
  assert(vec1D_real[2] == 3.33);
  assert(vec1D_real[3] == -0.125);
  assert(vec1D_real[4] == -0.67);
  assert(vec1D_real[5] == -2.21);
  ghaGEnd();

  ghaGStart("Unconstrained natural 1D array of Boolean");
  bool* vec1D_bool;
  vffiNaturalDimArrGet(v_natural1D_bool, (void**)&vec1D_bool, len, 1);
  printf("vec1D_bool : %p [%d]\n", vec1D_bool, len[0]);
  assert(vec1D_bool[0] == 0);
  assert(vec1D_bool[1] == 1);
  assert(vec1D_bool[2] == 1);
  assert(vec1D_bool[3] == 0);
  ghaGEnd();

  ghaGStart("Unconstrained natural 1D array of Bit");
  bool* vec1D_bit;
  vffiNaturalDimArrGet(v_natural1D_bit, (void**)&vec1D_bit, len, 1);
  printf("vec1D_bit  : %p [%d]\n", vec1D_bit, len[0]);
  assert(vec1D_bit[0] == 1);
  assert(vec1D_bit[1] == 0);
  assert(vec1D_bit[2] == 1);
  assert(vec1D_bit[3] == 0);
  ghaGEnd();

  ghaGStart("Unconstrained natural 1D array of Time");
  int64_t* vec1D_time;
  vffiNaturalDimArrGet(v_natural1D_time, (void**)&vec1D_time, len, 1);
  printf("vec1D_time  : %p [%d]\n", vec1D_time, len[0]);
  assert(vec1D_time[0] == 1e6);
  assert(vec1D_time[1] == 50e3);
  assert(vec1D_time[2] == 1.34e9);
  ghaGEnd();

  ghaGStart("Unconstrained natural 1D array of Record");
  rec_t* vec1D_rec;
  vffiNaturalDimArrGet(v_natural1D_rec, (void**)&vec1D_rec, len, 1);
  printf("vec1D_rec  : %p [%d]\n", vec1D_rec, len[0]);
  assert(vec1D_rec[0].r_char == 'x');
  assert(vec1D_rec[0].r_int == 17);
  assert(vec1D_rec[1].r_char == 'y');
  assert(vec1D_rec[1].r_int == 25);
  ghaGEnd();

  ghaGStart("Unconstrained natural 1D array of Enumeration");
  uint8_t* vec1D_enum;
  vffiNaturalDimArrGet(v_natural1D_enum, (void**)&vec1D_enum, len, 1);
  printf("vec1D_enum : %p [%d]\n", vec1D_enum, len[0]);
  assert(vec1D_enum[0] == start);
  assert(vec1D_enum[1] == busy);
  assert(vec1D_enum[2] == standby);
  ghaGEnd();

  ghaGStart("Unconstrained natural 2D array of Real");
  double* vec2D_real_base;
  vffiNaturalDimArrGet(v_natural2D_real, (void**)&vec2D_real_base, len, 2);
  double (*vec2D_real)[len[0]] = (double(*)[len[0]])vec2D_real_base;
  assert(vec2D_real[0][0] == 0.1);
  assert(vec2D_real[0][1] == 0.25);
  assert(vec2D_real[0][2] == 0.5);
  assert(vec2D_real[1][0] == 3.33);
  assert(vec2D_real[1][1] == 4.25);
  assert(vec2D_real[1][2] == 5.0);
  printf("v_natural2D_real : %p [%d, %d]\n", vec2D_real, len[1], len[0]);
}
