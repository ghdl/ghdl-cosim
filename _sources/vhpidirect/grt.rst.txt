.. program:: ghdl

.. _COSIM:VHPIDIRECT:GRT:

Using GRT
#########

From Ada
========

.. WARNING::
  This topic is only for advanced users who know how to use `Ada`
  and `GNAT`. This is provided only for reference; we have tested
  this once before releasing `GHDL` 0.19, but this is not checked at
  each release.

The simulator kernel of `GHDL` named :dfn:`GRT` is written in
`Ada95` and contains a very light and slightly adapted version
of `VHPI`. Since it is an `Ada` implementation it is
called :dfn:`AVHPI`. Although being tough, you may interface to `AVHPI`.

For using `AVHPI`, you need the sources of `GHDL` and to recompile
them (at least the `GRT` library). This library is usually compiled with
a `No_Run_Time` pragma, so that the user does not need to install the
`GNAT` runtime library. However, you certainly want to use the usual
runtime library and want to avoid this pragma. For this, reset the
`GRT_PRAGMA_FLAG` variable.

::

  $ make GRT_PRAGMA_FLAG= grt-all


Since `GRT` is a self-contained library, you don't want
`gnatlink` to fetch individual object files (furthermore this
doesn't always work due to tricks used in `GRT`). For this,
remove all the object files and make the :file:`.ali` files read-only.

::

  $ rm *.o
  $ chmod -w *.ali


You may then install the sources files and the :file:`.ali` files. I have never
tested this step.

You are now ready to use it.

Here is an example, :file:`test_grt.adb` which displays the top
level design name.

.. code-block:: Ada

  with System; use System;
  with Grt.Avhpi; use Grt.Avhpi;
  with Ada.Text_IO; use Ada.Text_IO;
  with Ghdl_Main;

  procedure Test_Grt is
    --  VHPI handle.
    H : VhpiHandleT;
    Status : Integer;

    --  Name.
    Name : String (1 .. 64);
    Name_Len : Integer;
  begin
    --  Elaborate and run the design.
    Status := Ghdl_Main (0, Null_Address);

    --  Display the status of the simulation.
    Put_Line ("Status is " & Integer'Image (Status));

    --  Get the root instance.
    Get_Root_Inst(H);

    --  Disp its name using vhpi API.
    Vhpi_Get_Str (VhpiNameP, H, Name, Name_Len);
    Put_Line ("Root instance name: " & Name (1 .. Name_Len));
  end Test_Grt;


First, analyze and bind your design::

  $ ghdl -a counter.vhdl
  $ ghdl --bind counter


Then build the whole::

  $ gnatmake test_grt -aL`grt_ali_path` -aI`grt_src_path` -largs
   `ghdl --list-link counter`


Finally, run your design::

  $ ./test_grt
  Status is  0
  Root instance name: counter

