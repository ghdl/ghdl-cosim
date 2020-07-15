#include <stdio.h>
#include <malloc.h>

extern int ghdl_main(char argc, char* argv[]);

int arraySize;
int *intArray;

int getIntArrSize(){
	return arraySize;
}

int* getIntArr_ptr(){
	return intArray;
}

void printIntArr() {
  for (int i = 0; i < arraySize; i++) {
    printf("intArray[%d]: %d\n", i, intArray[i]);
  }
}

int main(char argc, char* argv[]){
	printf("Hello main!\n");

	arraySize = 4;
	intArray = (int*)malloc(arraySize*sizeof(int));

	for(int i = 0; i < arraySize; i++){
		intArray[i] = 13*(i+1);
	}

	printIntArr();

	printf("GHDL Simulation Begin\n");
	int ghdlReturn = ghdl_main(argc, argv);
	printf("GHDL Simulation End <%d>\n", ghdlReturn);

	printIntArr();

	free(intArray);

	return ghdlReturn;
}
