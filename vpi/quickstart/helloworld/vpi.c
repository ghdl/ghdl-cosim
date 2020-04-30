#include <vpi_user.h>
#include <stdio.h>

PLI_INT32 delay_ro_cb(p_cb_data data){
    (void) data;
    printf("Hello world! \n");
    vpi_control(vpiFinish, 0);
    return 0;
}

void entry_point_cb() {

    s_cb_data cbData;
    s_vpi_time simuTime;
        
    cbData.time = &simuTime;
    simuTime.type = vpiSimTime;
    simuTime.high = 0;
    simuTime.low = 0;

    cbData.reason = cbAfterDelay;
    cbData.cb_rtn = delay_ro_cb;
    cbData.user_data = 0;
    cbData.value = 0;

    vpi_register_cb(&cbData);

}

void (*vlog_startup_routines[]) () = {
    entry_point_cb,
    0
};
