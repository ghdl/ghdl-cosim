#include<stdio.h>

int var;

int* getInt_ptr(){
    return &var;
}

void printInt(){
    printf("C-side print of int: %d\n", var);
}
