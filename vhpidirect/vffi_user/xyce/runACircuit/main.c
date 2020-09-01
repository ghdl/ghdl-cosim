#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <assert.h>
#include <string.h>

#include <N_CIR_XyceCInterface.h>
#include <vffi_user.h>

uint32_t xyce(vffiNaturalDimArr_t* ptr) {
    char* cir = vffiNullTerminatedString(ptr);

    printf("VHPIDIRECT: entering xyce %s\n", cir);

    void** hnd = (void **) malloc( sizeof(void* [1]) );

    char *argList[] = {
        (char*)("Xyce"),
        (char*)("-quiet"),
        //(char*)("-o"),
        //(char*)("testOutput"),
        (char*)(cir),
    };

    int status;

    xyce_open(hnd);

    status = xyce_initialize(hnd, sizeof(argList)/sizeof(argList[0]), argList);
    assert( status == 1);
    assert( hnd != NULL );

    status = xyce_runSimulation(hnd);
    assert( status == 1);

    xyce_close(hnd);
    free(hnd);

    printf("VHPIDIRECT: exiting xyce\n");
    return status;
}
