#include <stdio.h>

void custom_procedure (void) {
  printf("Hello from custom_procedure!\n");
}

void custom_procedure_withargs (int x) {
  printf("Hello from custom_procedure '%d'!\n", x);
}

int custom_function (void) {
  return 3;
}

int custom_function_withargs (int x) {
  return x+5;
}
