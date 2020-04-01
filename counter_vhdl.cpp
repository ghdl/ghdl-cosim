#include "systemc.h"

struct ghdl_entity_link {
  void *rti;
  void *parent;
};

struct ghdl_signal;

typedef unsigned char std__standard__bit;

struct counter_INSTTYPE {
  struct ghdl_entity_link RTI;

  struct ghdl_signal *clk_SIG;
  std__standard__bit *clk_VALP;

  struct ghdl_signal *reset_SIG;
  std__standard__bit *reset_VALP;

  struct ghdl_signal *enable_SIG;
  std__standard__bit *enable_VALP;

  struct ghdl_signal *counter_out_SIG[4];
  std__standard__bit *counter_out_VALP;
};

extern "C" {
  extern void *__ghdl_rti_top_instance;
  struct ghdl_process;
  void grt_init (void);
  int grt_main_init (const char *progname, int argc, const char * const argv[]);
  int grt_main_elab (void);
  void __ghdl_process_add_driver (struct ghdl_signal *);
  void __ghdl_process_add_sensitivity (struct ghdl_signal *);
  struct ghdl_process *__ghdl_register_foreign_process (void *instance,
							void (*proc)(void *));
  void __ghdl_set_current_process (struct ghdl_process *);
  void __ghdl_signal_simple_assign_e8 (struct ghdl_signal *, int);

  void __ghdl_simulation_init (void);
  int __ghdl_simulation_step (void);
};

//  Fake VHDL process representing drivers for signals.
static void vhdl_driver_process (void *inst)
{
  //cout << "vhdl_driver_process called" << endl;
}

static void vhdl_counter_driver_process (void *inst);

SC_MODULE (first_counter) {
  //  External interface.
  sc_in_clk     clock ;      // Clock input of the design
  sc_in<bool>   reset ;      // active high, synchronous Reset input
  sc_in<bool>   enable;      // Active high enable signal for counter
  sc_out<sc_uint<4> > counter_out; // 4 bit vector output of the counter

  //  Internal implementation.
  sc_event vhdl_cycle_ev;
  struct counter_INSTTYPE *instance;
  struct ghdl_process *driver_proc;

  void clock_adapt (void) {
    //cout << "clock event: " << clock << endl;
    __ghdl_set_current_process (driver_proc);
    __ghdl_signal_simple_assign_e8 (instance->clk_SIG, clock);
    vhdl_cycle_ev.notify(SC_ZERO_TIME);
  }

  void reset_adapt (void) {
    //cout << "reset event: " << reset << endl;
    __ghdl_set_current_process (driver_proc);
    __ghdl_signal_simple_assign_e8 (instance->reset_SIG, reset);
    vhdl_cycle_ev.notify(SC_ZERO_TIME);
  }

  void enable_adapt (void) {
    //cout << "enable event: " << enable << endl;
    __ghdl_set_current_process (driver_proc);
    __ghdl_signal_simple_assign_e8 (instance->enable_SIG, enable);
    vhdl_cycle_ev.notify(SC_ZERO_TIME);
  }

  void counter_adapt (void) {
    struct counter_INSTTYPE *inst = instance;
    unsigned int v = 0;
    for (int i = 0; i < 4; i++)
      v = (v << 1) | inst->counter_out_VALP[i];
    //cout << "counter event: " << v << endl;
    counter_out = v;
  }

  void vhdl_cycle (void) {
    //cout << "vhdl cycle" << endl;
    if (__ghdl_simulation_step () == 0)
      vhdl_cycle_ev.notify(SC_ZERO_TIME);
  }

  SC_CTOR(first_counter) {
    //  Elaborate instance.
    grt_init (); // Elab Ada code
    grt_main_init (sc_argv()[0], sc_argc (), sc_argv()); //  Init grt
    grt_main_elab (); //  Elaborate vhdl unit
    instance = (struct counter_INSTTYPE *) __ghdl_rti_top_instance;

    //  Register an external process and add drivers for inputs
    driver_proc = __ghdl_register_foreign_process (this, &vhdl_driver_process);
    __ghdl_process_add_driver (instance->clk_SIG);
    __ghdl_process_add_driver (instance->reset_SIG);
    __ghdl_process_add_driver (instance->enable_SIG);
    //  Register an external process and add sensitivity for outputs
    __ghdl_register_foreign_process (this, &vhdl_counter_driver_process);
    for (int i = 0; i < 4; i++)
      __ghdl_process_add_sensitivity (instance->counter_out_SIG[i]);

    cout<<"Executing new for VHDL"<<endl;
    SC_METHOD(clock_adapt);
    sensitive << clock;
    SC_METHOD(reset_adapt);
    sensitive << reset;
    SC_METHOD(enable_adapt);
    sensitive << enable;
    SC_METHOD(vhdl_cycle);
    sensitive << vhdl_cycle_ev;
  }

  void end_of_elaboration () {
    //cout << "end of elab" << endl;
    __ghdl_simulation_init ();
  }
};

static void vhdl_counter_driver_process (void *inst)
{
  first_counter *fc = static_cast<first_counter *>(inst);
  fc->counter_adapt ();
}
