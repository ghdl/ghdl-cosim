#include <vpi_user.h>
#include <stdio.h>
#include "common_vpi.h"

void print_net_in_module(vpiHandle module_handle) {
    char* module_name = vpi_get_str(vpiName, module_handle);
    vpiHandle net_handle;

    printf(" Signals of %s: \n", module_name);
    vpiHandle net_iterator = vpi_iterate(vpiNet,module_handle);
    if(net_iterator){
        while(net_handle = vpi_scan(net_iterator)){
            char* net_full_name = vpi_get_str(vpiFullName, net_handle);
            printf("  %s \n", net_full_name);
            vpi_free_object(net_handle);
        }
    } 
}

void print_signals(){
        
    vpiHandle top_mod_iterator;
    vpiHandle top_mod_handle;

    top_mod_iterator = vpi_iterate(vpiModule,NULL);
    
    top_mod_handle = vpi_scan(top_mod_iterator);
    while(top_mod_handle) {
        print_net_in_module(top_mod_handle);
        vpiHandle module_iterator = vpi_iterate(vpiModule,top_mod_handle);
        if (module_iterator){
            vpiHandle module_handle;
            module_handle = vpi_scan(module_iterator);
            while (module_handle) {
                print_net_in_module(module_handle);
                vpi_free_object(module_handle);
                module_handle = vpi_scan(module_iterator);
            }
        }
        vpi_free_object(top_mod_handle);
        top_mod_handle = vpi_scan(top_mod_iterator);
    }
}

PLI_INT32 start_cb(p_cb_data data){
    (void) data;
    
    printf("Start of simulation \n");
    printf("List of simulation signals: \n");
    print_signals();

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
}

void (*vlog_startup_routines[]) () = {
    entry_point_cb,
    0
};
