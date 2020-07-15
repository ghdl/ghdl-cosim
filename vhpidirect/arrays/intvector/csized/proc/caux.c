#define SIZE_ARRAY 6

int getIntArrSize(){
    return SIZE_ARRAY;
}

void getIntArr(int* arr){
    int i;
    for (i=0 ; i<SIZE_ARRAY ; i++) {
        arr[i] = (i+1)*11;
    }
}
