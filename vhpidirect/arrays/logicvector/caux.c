#include <stdio.h>
#define SIZE_LOGIC_VEC_A (sizeof(logic_vec_A)/sizeof(char))
#define SIZE_LOGIC_VEC_B 6

static const char HDL_LOGIC_CHAR[] = { 'U', 'X', '0', '1', 'Z', 'W', 'L', 'H', '-'};

enum HDL_LOGIC_STATES {
HDL_U = 0,
HDL_X = 1,
HDL_0 = 2,
HDL_1 = 3,
HDL_Z = 4,
HDL_W = 5,
HDL_L = 6,
HDL_H = 7,
HDL_D = 8,
};

// Vector A

char logic_vec_A[3];

int getLogicVecSize(char returnA){
	if(returnA)
		return SIZE_LOGIC_VEC_A;
	else
		return SIZE_LOGIC_VEC_B;
}

char* getLogicVecA(){
	//The HDL_LOGIC_STATES enum is used
	logic_vec_A[0] = HDL_U;
	logic_vec_A[1] = HDL_X;
	logic_vec_A[2] = HDL_0;

	printf("A: 1D Array Logic Values [%ld]:\n", SIZE_LOGIC_VEC_A);
	for(int i = 0; i < SIZE_LOGIC_VEC_A; i++){
		printf("[%d] = %c\t", i, HDL_LOGIC_CHAR[logic_vec_A[i]]);
	}
	printf("\n");
	return logic_vec_A;
}

// Vector B

void getLogicVecB(char* vec){
	//The equivalent value of HDL_LOGIC_STATES is used
	printf("B: 1D Array Logic Values [%ld]:\n", SIZE_LOGIC_VEC_B);
	for(int i = 0; i < SIZE_LOGIC_VEC_B; i++){
		vec[i] = 8-i; //The last 'SIZE_LOGIC_VEC_B' HDL_LOGIC values, in reverse order.
		printf("[%d] = %c\t", i, HDL_LOGIC_CHAR[vec[i]]);
	}
	printf("\n");
}
