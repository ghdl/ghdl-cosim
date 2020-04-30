#pragma once
#include <inttypes.h>
#include <vpi_user.h>

/*
 * register_cb is a wrapper function around vpi_register_cb
 * to simplify the the callback registering process
 */
void register_cb(PLI_INT32(*f)(p_cb_data),
                 PLI_INT32 reason,
                 int64_t cycles){

    s_cb_data cbData;
    s_vpi_time simuTime;
    if (cycles < 0){
        cbData.time = NULL;
    } else {
        cbData.time = &simuTime;
        simuTime.type = vpiSimTime;
        simuTime.high = (PLI_INT32) (cycles >> 32);
        simuTime.low = (PLI_INT32) (cycles & 0xFFFFFFFF);
    }

    cbData.reason = reason;
    cbData.cb_rtn = f;
    cbData.user_data = 0;
    cbData.value = 0;

    vpi_register_cb(&cbData);
}

