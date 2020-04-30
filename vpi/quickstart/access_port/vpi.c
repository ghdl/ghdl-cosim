#include <vpi_user.h>
#include <stdio.h>
#include "common_vpi.h"

PLI_INT32 start_cb(p_cb_data data){
    (void) data;

    // VPI value structure
    s_vpi_value val;
    
    // type of data format that is passed to the runtime.
    val.format = vpiBinStrVal;
    val.value.str = "0101";
    printf("set %s in tb.nibble1 \n", val.value.str);
    
    //vpi_handle_by_name returns an arbitrary port/signal in the
    //simulation hierarchy
    vpiHandle nibble1 = vpi_handle_by_name("tb.nibble1", NULL);

    //vpi_put_value set the value to the passed signal handle
    vpi_put_value(nibble1, &val, NULL, vpiNoDelay);
    
    val.value.str = "0011";
    printf("set %s in tb.nibble2 \n", val.value.str);
    vpiHandle nibble2 = vpi_handle_by_name("tb.nibble2", NULL);
    vpi_put_value(nibble2, &val, NULL, vpiNoDelay);

    return 0;
}

PLI_INT32 end_cb(p_cb_data data){
    (void) data;
    s_vpi_value val;
    
    val.format = vpiBinStrVal;
    vpiHandle sum = vpi_handle_by_name("tb.sum", NULL);

    //vpi_get_value reads the value from the passed signal handle
    vpi_get_value(sum, &val);
    printf("get %s from tb.sum \n", val.value.str);

    return 0;
}

void entry_point_cb() {
    register_cb(start_cb, cbStartOfSimulation, -1);
    register_cb(end_cb, cbEndOfSimulation, -1);
}

void (*vlog_startup_routines[]) () = {
    entry_point_cb,
    0
};
