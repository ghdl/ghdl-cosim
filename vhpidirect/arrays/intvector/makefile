EXAMPLE_DIRS = ./csized ./vhdlsized

# Default
afresh : clean run

run : 
	$(foreach dir,$(EXAMPLE_DIRS),$(MAKE) -C $(dir)/ run;)

# Clean

clean:
	$(foreach dir,$(EXAMPLE_DIRS),$(MAKE) -C $(dir)/ clean;)