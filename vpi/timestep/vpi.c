#include<vpi_user.h>
#include<inttypes.h>
#include<stdio.h>
#include "common_vpi.h"

#define STOP_ITERATION 10

uint32_t iteration = 0;


PLI_INT32 rw_cb(p_cb_data);
PLI_INT32 ro_cb(p_cb_data);
PLI_INT32 delay_rw_cb(p_cb_data);
PLI_INT32 delay_ro_cb(p_cb_data);

PLI_INT32 rw_cb(p_cb_data data){
    (void) data;

    printf("Timestep %d \n", iteration);

    // all write accesses to signals must go HERE

    if(iteration < STOP_ITERATION) {
    
        // change the last parameter to modify the simulation delay induced by the iteration
        register_cb(delay_ro_cb, cbAfterDelay, 1); 
    } else {
        vpi_control(vpiFinish, 0);
    }

    iteration++;
    return 0;
}

PLI_INT32 ro_cb(p_cb_data data){
    (void) data;
    register_cb(delay_rw_cb, cbAfterDelay, 0);
    return 0;
}

PLI_INT32 delay_rw_cb(p_cb_data data){
    (void) data;
    register_cb(rw_cb, cbReadWriteSynch, 0);
    return 0;
}

PLI_INT32 delay_ro_cb(p_cb_data data){
    (void) data;
    register_cb(ro_cb, cbReadOnlySynch, 0);
    return 0;
}

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
    register_cb(start_cb, cbStartOfSimulation, -1);
    register_cb(end_cb, cbEndOfSimulation, -1);
    register_cb(delay_ro_cb, cbAfterDelay, 0);
}

void (*vlog_startup_routines[]) () = {
    entry_point_cb,
    0
};
