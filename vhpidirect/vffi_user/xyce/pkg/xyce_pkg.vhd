use work.xyce_xhdl_pkg.all;

package xyce_pkg is

  alias arr2D_t is work.xyce_xhdl_pkg.arr2D_t;

  type xyce_t is protected
    procedure init (
      id      : string;
      circuit : string
    );

    procedure run (
      reqT : real
    );

    procedure run (
      reqT    : real;
      arrTime : real_vector;
      arrVolt : real_vector
    );

    procedure run (
      reqT  : real;
      arr2D : arr2D_t
    );

    impure function reqT return real;

    impure function read (
      name : string
    ) return real;

    procedure close;
  end protected;

end xyce_pkg;
