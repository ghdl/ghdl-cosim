#include <vpi_user.h>
#include <stdio.h>

/*
 * Delay callback
 */
PLI_INT32 delay_ro_cb(p_cb_data data){
    (void) data;
    printf("Hello world! \n");

    //vpi_control with vpiFinish asks the simulator to terminate
    //the second argument is the return value
    vpi_control(vpiFinish, 0);
    return 0;
}

/*
 * Main entry point
 */
void entry_point_cb() {

    // VPI callback structure
    s_cb_data cbData;
    // VPI simulation time structure
    s_vpi_time simuTime;
    
    // The callback is executed after a delay
    cbData.reason = cbAfterDelay;
    cbData.cb_rtn = delay_ro_cb;
    cbData.user_data = 0;
    cbData.value = 0;

    // the callback is executed after a delay of 0
    cbData.time = &simuTime;
    simuTime.type = vpiSimTime;
    simuTime.high = 0;
    simuTime.low = 0;

    // the callback is registered with vpi_register_cb
    vpi_register_cb(&cbData);

}

/* 
 * vlog_startup_routines[] is a list of entry points that are
 * called when the VPI plugin is loaded by the simulator
 */
void (*vlog_startup_routines[]) () = {
    entry_point_cb,
    0
};
