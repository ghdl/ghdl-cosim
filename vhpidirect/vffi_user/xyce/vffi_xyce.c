#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <N_CIR_XyceCInterface.h>

#include "vffi_user.h"
#include "vffi_xyce_storage.h"

//--

uint32_t _configDACs(
  xhdl_t* item
);

uint32_t xhdl_init(
  vffiNaturalDimArr_t* ptr,
  vffiNaturalDimArr_t* cir
);

uint32_t xhdl_run(
  vffiNaturalDimArr_t* ptr,
  double requestedUntilTime
);

uint32_t xhdl_run_1D(
  vffiNaturalDimArr_t* ptr,
  double requestedUntilTime,
  vffiNaturalDimArr_t* tArray,
  vffiNaturalDimArr_t* vArray
);

uint32_t xhdl_run_2D(
  vffiNaturalDimArr_t* ptr,
  double requestedUntilTime,
  vffiNaturalDimArr_t* array2D
);

double xhdl_read(
  vffiNaturalDimArr_t* ptr,
  vffiNaturalDimArr_t* name
);

void xhdl_close(
  vffiNaturalDimArr_t* ptr
);

//--

uint32_t _configDACs(xhdl_t* item) {
  // Get the number of YADC and YDAC in the netlist, and maximum name lengths
  // for each type of device. This allows for better sizing of the ADCnames
  // and DACnames char arrays.
  int maxADCnameLength = 0;  int* maxADCnameLengthPtr = &maxADCnameLength;
  int maxDACnameLength = 0;  int* maxDACnameLengthPtr = &maxDACnameLength;

  item->ADC->num = malloc(sizeof(uint));
  item->DAC->num = malloc(sizeof(uint));

  xyce_getNumDevices(item->ptr, (char *)"YADC", item->ADC->num, maxADCnameLengthPtr);
  xyce_getNumDevices(item->ptr, (char *)"YDAC", item->DAC->num, maxDACnameLengthPtr);

  if (*(item->ADC->num) == 0 && *(item->DAC->num) == 0) {
    printf("_configDACs: No ADCs or DACs found!\n");
    return 0;
  }

  printf("_configDACs: ADC names [num , max length]: %d %d\n", *(item->ADC->num), maxADCnameLength);
  printf("_configDACs: DAC names [num , max length]: %d %d\n", *(item->DAC->num), maxDACnameLength);

  // Initialize arrays of char array

  item->ADC->names = (char **) malloc( *(item->ADC->num) * sizeof(char*) );
  item->DAC->names = (char **) malloc( *(item->DAC->num) * sizeof(char*) );

  int i; // loop counter
  for (i = 0; i < *(item->ADC->num); i++) {
    item->ADC->names[i] = (char *) malloc( maxADCnameLength*sizeof(char) );
  }
  for (i = 0; i < *(item->DAC->num); i++) {
    item->DAC->names[i] = (char *) malloc( maxDACnameLength*sizeof(char) );
  }

  xyce_getDeviceNames(item->ptr, (char *)"YADC", item->ADC->num, item->ADC->names);
  xyce_getDACDeviceNames(item->ptr, item->DAC->num, item->DAC->names);

  printf("Found %d ADC devices\n",*(item->ADC->num));
  for (i = 0; i < *(item->ADC->num); i++) {
    printf("ADC Name %d: %s\n", i, item->ADC->names[i]);
  }

  printf("Found %d DACs\n",*(item->DAC->num));
  for (i = 0; i < *(item->DAC->num); i++) {
    printf("DAC Name %d: %s\n", i, item->DAC->names[i]);
  }
}


uint32_t xhdl_init(vffiNaturalDimArr_t* ptr, vffiNaturalDimArr_t* cir) {
  int z = st_get_free();
  assert( z >= 0 );

  char* id = vffiNullTerminatedString(ptr);
  char *circuit = vffiNullTerminatedString(cir);

  printf("DEBUG: xhdl_init <%s> [%d]\n", id, z);

  void** p = (void **) malloc( sizeof(void* [1]) );

  xhdl_db[z] = new_xhdl(id, p);

  char *argList[] = {
      (char*)("Xyce"),
      //(char*)("-quiet"),
      //(char*)("-o"),
      //(char*)("testOutput"),
      (char*)(circuit),
  };

  int status;

  xyce_open(p);

  status = xyce_initialize(p, sizeof(argList)/sizeof(argList[0]), argList);
  assert( status == 1);
  assert( p != NULL );

  _configDACs(xhdl_db[z]);

  // A bug in the DAC device (put there for Habinero support) only takes
  // the last time in the time voltage pairs list if the current sim time is 0.
  // So simulate a bit first.
  status = xyce_simulateUntil(p, 1.0e-10, xhdl_db[z]->time );
  assert(status == 1);

  return status;
}


int _get_st_id_from_ptr(vffiNaturalDimArr_t* ptr) {
  char* id = vffiNullTerminatedString(ptr);
  uint z = st_find(id);
  printf("DEBUG: _get_st_id_from_ptr %d %s\n", z, id);
  assert(z >= 0);
  return z;
}


int _run_simulation(int z, double requestedUntilTime) {
  void** p = xhdl_db[z]->ptr;
  assert(p != NULL);
  int status = ( requestedUntilTime == 0 ) ? xyce_runSimulation(p)
  : xyce_simulateUntil(p, requestedUntilTime, xhdl_db[z]->time );
  assert( status == 1);
  return status;
}


uint32_t xhdl_run(vffiNaturalDimArr_t* ptr, double requestedUntilTime) {
  int z = _get_st_id_from_ptr(ptr);
  printf("DEBUG: xhdl_run [%d] <%f>\n", z, requestedUntilTime);
  return _run_simulation(z, requestedUntilTime);
}


uint32_t xhdl_run_1D(vffiNaturalDimArr_t* ptr, double requestedUntilTime, vffiNaturalDimArr_t* tArray, vffiNaturalDimArr_t* vArray) {
  int z = _get_st_id_from_ptr(ptr);

  void** p = xhdl_db[z]->ptr;
  assert(p != NULL);

  int* len = malloc(2 * sizeof(int));

  double* tArr;
  double* vArr;

  vffiNaturalDimArrGet(tArray, (void**)&tArr, &(len[0]), 1);
  vffiNaturalDimArrGet(vArray, (void**)&vArray, &(len[1]), 1);

  printf("DEBUG: xhdl_run_1D [%d] <%f> <%p, %d> <%p, %d>\n", z, requestedUntilTime, tArray, len[0], vArray, len[1]);

  assert(len[0] == len[1]);

  uint numPoints = len[0];

  if ( numPoints != 0 ) {
    for (int y=0; y<numPoints; y++) {
      printf("[%d]: %f %f\n", y, tArr[y], vArr[y]);
    }
    assert(1 == xyce_updateTimeVoltagePairs(
      p,
      xhdl_db[z]->DAC->names[0],
      numPoints,
      tArr,
      vArr
    ));
  }

  return _run_simulation(z, requestedUntilTime);
}


uint32_t xhdl_run_2D(vffiNaturalDimArr_t* ptr, double requestedUntilTime, vffiNaturalDimArr_t* array2D) {
  int z = _get_st_id_from_ptr(ptr);

  void** p = xhdl_db[z]->ptr;
  assert(p != NULL);

  int* len = malloc(2 * sizeof(int));
  vhpiIntT* vec2D_real_base;
  vffiNaturalDimArrGet(array2D, (void**)&vec2D_real_base, len, 2);
  double (*vec2D_real)[len[0]] = (double(*)[len[0]])vec2D_real_base;

  printf("DEBUG: xhdl_run_2D [%d] <%f> <%d, %d> <%p> <%p> <%p>\n", z, requestedUntilTime, len[0], len[1], array2D, vec2D_real_base, vec2D_real);

  uint numPoints = len[0];

  if ( numPoints != 0 ) {
    for (int x=1; x<len[1]; x++) {
      for (int y=0; y<numPoints; y++) {
        printf("[%d, %d]: %f %f\n", x, y, vec2D_real[0][y], vec2D_real[x][y]);
      }
      assert(1 == xyce_updateTimeVoltagePairs(
        p,
        xhdl_db[z]->DAC->names[x-1],
        numPoints,
        vec2D_real[0],
        vec2D_real[x]
      ));
    }
  }

  return _run_simulation(z, requestedUntilTime);
}


double xhdl_read(vffiNaturalDimArr_t* ptr, vffiNaturalDimArr_t* name) {
  char* id = vffiNullTerminatedString(ptr);
  char* n = vffiNullTerminatedString(name);
  uint z = st_find(id);
  assert(z >= 0);
  printf("DEBUG: xhdl_run <%s> [%d] <%s>\n", id, z, n);

  void** p = xhdl_db[z]->ptr;
  assert(p != NULL);

  double* val = malloc(sizeof(double));
  xyce_obtainResponse(p, n, val);
  printf( "Result = %f\n", *val);

  return *val;
}


void xhdl_close(vffiNaturalDimArr_t* ptr) {
  char* id = vffiNullTerminatedString(ptr);
  printf("DEBUG: xhdl_run <%s>\n", id);

  uint z = st_find(id);
  assert(z >= 0);

  xyce_close(xhdl_db[z]->ptr);

  st_free_item(z);
}
