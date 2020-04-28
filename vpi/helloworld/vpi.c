#include <vpi_user.h>
#include <stdio.h>
#include "common_vpi.h"

PLI_INT32 start_cb(p_cb_data data){
    (void) data;
    printf("Start of simulation \n");
    return 0;
}

PLI_INT32 delay_ro_cb(p_cb_data data){
    (void) data;
    printf("Hello world! \n");
    vpi_control(vpiFinish, 0);
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
