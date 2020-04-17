#include <stdio.h>
#include <stdint.h>

extern int ghdl_main (int argc, char **argv);

int32_t V[10];

void write_int ( uint8_t id, int32_t v ) {
  V[id] = v;
}

int32_t read_int ( uint8_t id ) {
  return V[id];
}

void print_int ( uint8_t id ) {
  printf("C-side print of int: %d\n", V[id]);;
}
