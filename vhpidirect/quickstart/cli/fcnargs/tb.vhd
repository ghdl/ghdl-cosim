use work.pkg.all;

entity tb is
  generic (
    genInt : integer := getGenInt;
    genStr : string := "default string"
  );
end entity;
