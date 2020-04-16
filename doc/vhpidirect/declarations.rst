.. program:: ghdl

.. _COSIM:VHPIDIRECT:Declarations:

Type declarations
=================

Only subprograms (**functions** or **procedures**) can be imported using the foreign
attribute. In the following minimal :ref:`example <COSIM:VHPIDIRECT:Examples:quickstart:math>`,
the `sin` function is imported:

.. code-block:: VHDL

  package math is
    function sin (v : real) return real;
    attribute foreign of sin : function is "VHPIDIRECT sin";
  end math;

  package body math is
    function sin (v : real) return real is
    begin
      assert false severity failure;
    end sin;
  end math;

Requirements:

* A subprogram is made foreign if the ``foreign`` attribute decorates
  it.

* The ``attribute`` specification must be in the same declarative part as the
  subprogram and must be after it. This is a general rule for specifications.

* The value of the specification must be a locally static string.

* The value of the attribute must start with ``VHPIDIRECT`` (an upper-case keyword
  followed by one or more blanks). The linkage name of the subprogram follows. The
  path to a shared library can be optionally specified between the keyword and the
  name of the subprogram (see :ref:`COSIM:VHPIDIRECT:Examples:shared:shlib`).

* Even when a subprogram is foreign, its body must be present in VHDL. However, since
  it won't be called, you can make it empty or simply put an assertion. If the body
  is ever executed, that will mean that the foreign resource was not properly linked.

* Except for resources in the standard C library (which is linked by default), the
  object file with the source code for foreign subprogram(s) must then be linked to
  GHDL, expanded upon in :ref:`COSIM:VHPIDIRECT:Linking`.

.. NOTE::
  Attribute ``foreign`` is declared in the 1993 revision of the ``std.standard`` package.
  Therefore, it cannot be used in VHDL 1987.

.. _Restrictions_on_foreign_declarations:

Restrictions on type declarations
---------------------------------

Any subprogram can be imported. GHDL puts no restrictions on foreign
subprograms. However, the representation of a type or of an interface in a
foreign language may be obscure. Most non-composite types are easily imported:

*integer types*
  32 bit word. Generally, `int` for `C` or `Integer` for `Ada`.

*physical types*
  64 bit word. Generally, `long long` for `C` or `Long_Long_Integer` for `Ada`.

*floating point types*
  64 bit floating point word. Generally, `double` for `C` or `Long_Float` for `Ada`.

*enumeration types*
  8 bit word, or, if the number of literals is greater than 256, by a 32 bit word.
  There is no corresponding C type, since arguments are not promoted.

Non-composite types are passed by value. For the `in` mode (default), this corresponds
to the `C` or `Ada` mechanism. `out` and `inout` interfaces are gathered in a record and
this record is passed by reference as the first argument to the subprogram. As a
consequence, it is not suggested to use `out` and/or `inout` modes in foreign
subprograms, since they are not portable.

Composite types:

* Records are represented like a `C` structure and are passed by reference to subprograms.

* Arrays with static bounds are represented like a `C` array, whose length is the number
  of elements, and are passed by reference to subprograms.

* Unconstrained arrays are represented by a fat pointer. It is not suggested to use
  unconstrained arrays in foreign subprograms.

* Accesses to an unconstrained array are fat pointers. Other accesses correspond to an
  address/pointer and are passed to a subprogram like other non-composite types.

* Files are represented by a 32 bit word, which corresponds to an index in a table.
