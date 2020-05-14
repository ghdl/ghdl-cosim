CC=gcc
GHDL=ghdl

CFLAGS= -fPIC

STD=93

WORK_DIR=.

VHDL_DEPS = pkg.vhd tb.vhd 
VHDL_O_DEPS = $(patsubst %.vhd,%.o,$(VHDL_DEPS))

TOPLEVEL = tb

# Default
refresh : clean run

# Executable commands
run : calloc_tb vhdlalloc_tb

calloc_tb : pkg.o tb_calloc
	@echo "Execute tb_calloc"
	./tb_calloc
	@echo

vhdlalloc_tb : pkg.o tb_vhdlalloc
	@echo "Execute tb_vhdlalloc"
	./tb_vhdlalloc
	@echo

# Compile executable

tb_% : tb.o
	$(GHDL) -e --workdir=$(WORK_DIR)/ --std=$(STD) -Wl,caux.c -o $@ tb $(subst tb_,,$@)

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
