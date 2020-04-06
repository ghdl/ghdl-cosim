GHDL=ghdl
SYSTEM_C=/usr/local/systemc-2.3.1-inst/

INC_FLAGS=-I$(SYSTEM_C)/include
LDFLAGS=$(SYSTEM_C)/lib/libsystemc.a

CXX=g++
CFLAGS=-g

OBJS=first_counter_tb.o
OBJS_DEPS=counter.o e~counter.o

all: first_counter_tb

first_counter_tb: $(OBJS) $(OBJS_DEPS)
	$(CXX) -o $@ $(CFLAGS) $(OBJS) $(LDFLAGS) `$(GHDL) --list-link counter` 

first_counter_tb.o: first_counter_tb.cpp first_counter.cpp counter_vhdl.cpp
	$(CXX) -c -o $@ first_counter_tb.cpp $(CFLAGS) $(INC_FLAGS)

counter.o: counter.vhdl
	$(GHDL) -a counter.vhdl

e~counter.o: counter.o
	$(GHDL) --bind counter

clean:
	$(RM) *.o first_counter_tb
