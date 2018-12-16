module Adder (cin,y,z);
  parameter n = 64
  parameter delay = 60

  input [n-1:0] z,
  input [n-1:0] y,
  input cin,
  output [n-1:0] x,
  output cout;
  
  assign {cout, x} = z + y + cin;
  
endmodule