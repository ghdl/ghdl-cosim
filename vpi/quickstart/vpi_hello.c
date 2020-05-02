#include <vpi_user.h>
#include <stdio.h>

PLI_INT32 cb_hello(){
  printf("Hello!\n");
  return 0;
}

void entry_point_cb() {
  s_cb_data cb;

  cb.reason = cbStartOfSimulation;
  cb.cb_rtn = &cb_hello;
  cb.user_data = NULL;

  if (vpi_register_cb(&cb) == NULL) {
    vpi_printf ("cannot register cbStartOfSimulation call back\n");
  }
}

// List of entry points called when the plugin is loaded
void (*vlog_startup_routines[]) () = {entry_point_cb, 0};
