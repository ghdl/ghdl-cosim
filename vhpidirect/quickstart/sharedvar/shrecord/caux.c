#include <stdio.h>

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

struct Record {
	char logic;
	char logic_vec[8];
	int integer;
};

struct Record c_rec;

void printStruct(struct Record* rec){
	printf("Logic:\t\t%c\nInteger:\t%d\nLog_Vec:\t", HDL_LOGIC_CHAR[rec->logic], rec->integer);
	for (int i = 0; i < 8; i++)
	{
		printf("%c", HDL_LOGIC_CHAR[rec->logic_vec[i]]);
		if(i==3)
			printf("_");
	}
	printf("\n");
}

void printAndChangeStruct(struct Record* rec){
	printStruct(rec);
	rec->integer = 31;
}

struct Record* getStruct(){
	c_rec.logic = HDL_Z;
	c_rec.integer = 55;
	for (int i = 0; i < 8; i++)
		c_rec.logic_vec[i] = i;
	return &c_rec;
}
