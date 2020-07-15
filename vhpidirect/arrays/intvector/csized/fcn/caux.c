#define SIZE_ARRAY (sizeof(intArray)/sizeof(int))

int intArray[] = {11, 22, 33, 44, 55, 66};

int getIntArrSize(){
    return SIZE_ARRAY;
}

int* getIntArr_ptr(){
    return intArray;
}
