## VPI examples

The directory contains some VPI usage examples:

1. [quickstart/helloworld](./quickstart/helloworld/) minimal VPI code example that runs a simulation, prints a message and exits. 
2. [quickstart/beginend](./quickstart/helloworld/) VPI code example that executes a callback at the begin and the end of a simulation. 
3. [quickstart/access](./quickstart/access/) signal read/write example on an adder component using `vpi_put_value` and `vpi_get_value`.
4. [quickstart/timestep](./quickstart/timestep/) shows how to run a simulation for an arbitrary number of timesteps. 
5. [list](./list/) example on signal hierarchy iteration using `vpi_iterate`and `vpi_scan`.

to run a test, just go in the directory and execute 
```bash
sh run.sh
```

