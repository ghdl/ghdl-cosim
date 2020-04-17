#include <malloc.h>
#include <stddef.h>

int* intArray;
int* getIntArr_ptr(int arraySize){//function acts like a constructor so initialise the variable
    if(intArray == NULL && arraySize > 0){
        intArray = malloc(arraySize*sizeof(int));
        for (int i = 0; i < arraySize; i++)
        {
            intArray[i] = 11*(i+1);
        }
    }
    return intArray;
}

void freePointers(){
    free(intArray);
}