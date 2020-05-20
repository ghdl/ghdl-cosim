CC=gcc, GHDL=ghdl, CFLAGS= -fPIC, STD=93

WORK_DIR=.

VHDL_DEPS = tb.vhd 
VHDL_O_DEPS = $(patsubst %.vhd,%.o,$(VHDL_DEPS))

TOPLEVEL = tb

# Default
refresh : clean run

# Executable commands
run : tb tb_main

tb : c_tb
	@echo "Execute tb"
	./tb
	@echo

tb_main : main_tb
	@echo "Execute main_tb"
	./main_tb
	@echo

# Compile executable

main_% : %.o
	$(GHDL) -e --workdir=$(WORK_DIR)/ --std=$(STD) -Wl,main.c -o $@ $(subst main_,,$@)

c_% : %.o
	$(GHDL) -e --workdir=$(WORK_DIR)/ --std=$(STD) -Wl,caux.c $(subst c_,,$@)

%.o : %.vhd
	@echo "Analyze $<"
	$(GHDL) -a --std=$(STD) --workdir=$(WORK_DIR) $<

# Clean

.PHONY: clean

clean: clean_work clean_tb clean_tb_main

clean_tb:
	rm -f ./tb

clean_tb_main:
	rm -f ./tb_main

clean_work:
	rm -f $(WORK_DIR)/*.o $(WORK_DIR)/work-obj*.cf 
