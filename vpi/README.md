## VPI examples

The directory contains some VPI usage examples:

1. [helloworld](./helloworld/) minimal VPI code example that runs a simulation, prints a message and exits. 
2. [access](./access/) signal read/write example on an adder component using `vpi_put_value` and `vpi_get_value`.
3. [list](./list/) example on signal hierarchy iteration using `vpi_iterate`and `vpi_scan`.
4. [timestep](./timestep/) shows how to run a simulation for an arbitrary number of timesteps. 

to run a test, just go in the directory and execute 
```bash
sh run.sh
```

