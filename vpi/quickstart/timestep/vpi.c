#include<vpi_user.h>
#include<inttypes.h>
#include<stdio.h>
#include "common_vpi.h"

#define STOP_ITERATION 10

uint32_t iteration = 0;

/* In this example the simulation time is advanced from
 * VPI. This is accomplished registering a chain of callbacks.
 */

// register a cbAfterDelay callback that executes delay_ro_cb after 1 timestep
PLI_INT32 rw_cb(p_cb_data); 

// register a cbAfterDelay callback that executes delay_rw_cb after 0 timestep
PLI_INT32 ro_cb(p_cb_data);

// register a cbReadWriteSynch callback that execute rw_cb after 0 timestep
PLI_INT32 delay_rw_cb(p_cb_data);

// register a cbReadOnlySynch callback that executes ro_cb after 0 timestep
PLI_INT32 delay_ro_cb(p_cb_data);

PLI_INT32 rw_cb(p_cb_data data){
    (void) data;

    printf("Timestep %d \n", iteration);

    // all write accesses to signals must go HERE

    if(iteration < STOP_ITERATION) {
    
        // change the last parameter to modify the 
        // simulation delay induced by the iteration
        register_cb(delay_ro_cb, cbAfterDelay, 1); 
    } else {

        // if the chain is executed STOP_ITERATION times, the simulation is stopped
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

void entry_point_cb() {
    register_cb(delay_ro_cb, cbAfterDelay, 0);
}

void (*vlog_startup_routines[]) () = {
    entry_point_cb,
    0
};
