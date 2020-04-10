with System; use System;
with Ada.Calendar; use Ada.Calendar;
with Ada.Text_Io; use Ada.Text_Io;

procedure Showtime is
   function Ghdl_Main (Argc : Integer; Argv : Address; Envp : Address)
                      return Integer;
   pragma Import (C, Ghdl_Main);

   T1 : Time;
   T : Duration;
   Res : Integer;
begin
   Put_Line ("Before simulation");

   T1 := Clock;
   Res := Ghdl_Main (0, Null_Address, Null_Address);
   T := Clock - T1;

   Put_Line ("simulation duration: " & Duration'Image (T));
end Showtime;
