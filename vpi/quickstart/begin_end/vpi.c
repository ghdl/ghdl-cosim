#include <vpi_user.h>
#include <stdio.h>
#include "common_vpi.h"

PLI_INT32 start_cb(p_cb_data data){
    (void) data;
    printf("Start of simulation \n");
    return 0;
}

PLI_INT32 end_cb(p_cb_data data){
    (void) data;
    printf("End of simulation \n");
    return 0;
}


void entry_point_cb() {

    // cbStartOfSimulation is a callback executed at the beginning
    // of the simulation
    register_cb(start_cb, cbStartOfSimulation, -1);

    // cbStartOfSimulation is a callback executed at the beginning
    // of the simulation
    register_cb(end_cb, cbEndOfSimulation, -1);
}

void (*vlog_startup_routines[]) () = {
    entry_point_cb,
    0
};
