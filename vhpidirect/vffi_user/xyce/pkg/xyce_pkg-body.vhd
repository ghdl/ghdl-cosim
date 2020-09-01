package body xyce_pkg is

  type xyce_t is protected body

    type self_t is record
      id   : string;
      reqT : real;
    end record;
    type self_acc_t is access self_t;
    variable self : self_acc_t;

    procedure init (
      id      : string;
      circuit : string
    ) is
    begin
      self := new self_t'(
          id => id,
          reqT => 0.0
      );
      assert xyce_init(self.id, circuit) = 1 severity failure;
    end;

    procedure run (
      reqT : real
    ) is
    begin
      self.reqT := reqT;
      assert xyce_run(self.id, reqT) = 1 severity failure;
    end;

    procedure run (
      reqT    : real;
      arrTime : real_vector;
      arrVolt : real_vector
    ) is
    begin
      self.reqT := reqT;
      assert xyce_run(self.id, reqT, arrTime, arrVolt) = 1 severity failure;
    end;

    procedure run (
      reqT  : real;
      arr2D : arr2D_t
    ) is
    begin
      self.reqT := reqT;
      assert xyce_run(self.id, reqT, arr2D) = 1 severity failure;
    end;

    impure function reqT return real is
    begin
      return self.reqT;
    end;

    impure function read (
      name : string
    ) return real is
    begin
      return xyce_read(self.id, name);
    end;

    procedure close is
    begin
      xyce_close(self.id);
    end;

  end protected body;

end xyce_pkg;
