#include <assert.h>
#include <string.h>

typedef struct xhdl_c_t xhdl_c_t;

struct xhdl_c_t {
  char ** names;
  uint *  num;
};

xhdl_c_t* new_xhdl_c(){
  xhdl_c_t* conv = malloc(sizeof(xhdl_c_t));
  conv->names = NULL;
  conv->num = NULL;
  return conv;
}

void st_free_conv(xhdl_c_t* conv) {
  uint i;
  for (i = 0; i < *(conv->num); i++) {
    free(conv->names[i]);
  }
}

typedef struct xhdl_t xhdl_t;

struct xhdl_t {
 char     *  id;
 void     ** ptr;
 double   *  time;
 xhdl_c_t *  ADC;
 xhdl_c_t *  DAC;
};

#define NULL_XHDL (xhdl_t){.id = NULL, .ptr = 0, .time = 0, .cfg = NULL}

#define STORAGE_LENGTH 8

xhdl_t *xhdl_db[STORAGE_LENGTH];

xhdl_t* new_xhdl(char *id, void** ptr) {
  xhdl_t *item = (xhdl_t *) malloc(sizeof(xhdl_t));

  item->ptr = ptr;

  item->time = malloc(sizeof(double));
  *(item->time) = 0;

  item->ADC = new_xhdl_c();
  item->DAC = new_xhdl_c();

  item->id = malloc(strlen(id) + 1);
  assert(item->id != NULL);
  strcpy(item->id, id);

  return item;
}

int st_get_free() {
  int x;
  for ( x=0; x<STORAGE_LENGTH; x++ ) {
    if ( xhdl_db[x] == NULL ) {
      return x;
    }
  }
  return -1;
}

int st_find(char *id) {
  int x;
  for ( x=0; x<STORAGE_LENGTH; x++ ) {
  xhdl_t *item = xhdl_db[x];
  if ( item != NULL ) {
    if ( strcmp(item->id, id) == 0 ) {
      return x;
    }
  }
  }
  return -1;
}

void st_free_item(uint z) {
  free(xhdl_db[z]->id);
  free(xhdl_db[z]->ptr);
  free(xhdl_db[z]->time);
  st_free_conv(xhdl_db[z]->ADC);
  free(xhdl_db[z]->ADC);
  st_free_conv(xhdl_db[z]->DAC);
  free(xhdl_db[z]->DAC);
  free(xhdl_db[z]);
  xhdl_db[z] = NULL;
}
