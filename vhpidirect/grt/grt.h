void grt_init (void);
int grt_main_options (const char *progname, int argc, const char * const argv[]);
int grt_main_elab (void);
void __ghdl_simulation_init (void);
int __ghdl_simulation_step (void);
//  Return value:
//  0: delta cycle
//  1: non-delta cycle
//  2: stop
//  3: finished
//  4: stop-time reached
//  5: stop-delta reached
