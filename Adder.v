module Adder (cin,y,z);
  parameter delay = 60

  input [63:0] z,
  input [63:0] y,
  input cin,
  output [63:0] x,
  output cout;
  
  assign {cout, x} = z + y + cin;
  
endmodule
